import 'dart:convert';

import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores and retrieves cached LMS accounts on-device so a user can switch
/// between previously-signed-in accounts without retyping credentials.
///
/// This class ONLY caches data locally. It never talks to Supabase and never
/// performs authentication itself - that stays the caller's responsibility
/// (re-authenticate with Supabase using the cached email/password when the
/// user picks an account, then call [setCurrentAccount] on success).
///
/// Storage split:
/// - Account list (without passwords) -> shared_preferences, key [_accountsKey].
/// - Each password -> flutter_secure_storage, key '$_passwordPrefix$accountId'.
/// - Pointer to the active account id -> shared_preferences, key [_currentAccountIdKey].

class AccountManager {
  // AccountManager._();

  static const _accountsKey = 'cached_accounts_list';
  static const _currentAccountIdKey = 'current_account_id';
  static const _passwordPrefix = 'account_password_';

  static const _secureStorage = FlutterSecureStorage();

  // To get current user directly (BUGED)
  // late final CachedAccount? currentUser;
  // AccountManager() {
  //   _initializeCurrentUser();
  // }
  // Future<void> _initializeCurrentUser() async {
  //   currentUser = await currentAccount();
  // }

  // ---------------------------------------------------------------------
  // Current account
  // ---------------------------------------------------------------------

  /// Saves [account] into the accounts list (inserting or updating it) and
  /// marks it as the current account. Always call this AFTER a successful
  /// Supabase sign-in - this method does not validate credentials.
  static Future<void> setCurrentAccount(CachedAccount account) async {
    await _upsertAccount(account);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAccountIdKey, account.id);
  }

  /// Clears the "current account" pointer only. The account itself stays in
  /// the cached list so it still shows up for a quick switch-back later.
  static Future<void> setCurrentAccountNull() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentAccountIdKey);
  }

  /// Returns the currently active account, or null if none is set or the
  /// pointed-to account no longer exists in the cached list.
  static Future<CachedAccount?> currentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getString(_currentAccountIdKey);
    if (currentId == null) return null;

    final accounts = await accountsList();
    if (accounts == null) return null;

    for (final account in accounts) {
      if (account.id == currentId) return account;
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // Accounts list
  // ---------------------------------------------------------------------

  /// Returns all cached accounts (each with its password filled back in
  /// from secure storage), most-recently-signed-in first.
  /// Returns null if there are no cached accounts at all.
  static Future<List<CachedAccount>?> accountsList() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_accountsKey);
    if (rawList == null || rawList.isEmpty) return null;

    final accounts = <CachedAccount>[];
    for (final raw in rawList) {
      final accountWithoutPassword = CachedAccount.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      final password =
          await _secureStorage.read(
            key: _passwordKey(accountWithoutPassword.id),
          ) ??
          '';
      accounts.add(accountWithoutPassword.copyWithPassword(password));
    }

    accounts.sort((a, b) => b.lastSignIn.compareTo(a.lastSignIn));
    return accounts;
  }

  /// Removes a single cached account (its entry + its stored password).
  /// If it was the current account, the current-account pointer is cleared.
  static Future<void> removeAccount(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_accountsKey) ?? [];

    final updatedList = rawList.where((raw) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded['id'] != accountId;
    }).toList();

    await prefs.setStringList(_accountsKey, updatedList);
    await _secureStorage.delete(key: _passwordKey(accountId));

    final currentId = prefs.getString(_currentAccountIdKey);
    if (currentId == accountId) {
      await prefs.remove(_currentAccountIdKey);
    }
  }

  /// Wipes every cached account, all stored passwords, and the current
  /// account pointer. Use for a full "sign out everywhere" / app reset.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_accountsKey) ?? [];

    for (final raw in rawList) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      await _secureStorage.delete(key: _passwordKey(decoded['id'] as String));
    }

    await prefs.remove(_accountsKey);
    await prefs.remove(_currentAccountIdKey);
  }

  // ---------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------

  static String _passwordKey(String accountId) => '$_passwordPrefix$accountId';

  /// Inserts [account] if its id is new, or replaces the existing entry
  /// with the same id (e.g. on re-sign-in with a refreshed lastSignIn, or
  /// updated role/teacher/student/parent info). Password is stored
  /// separately in secure storage either way.
  static Future<void> _upsertAccount(CachedAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_accountsKey) ?? [];

    final updatedList = rawList.where((raw) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded['id'] != account.id;
    }).toList()..add(account.encodeWithoutPassword());

    await prefs.setStringList(_accountsKey, updatedList);
    await _secureStorage.write(
      key: _passwordKey(account.id),
      value: account.password,
    );
  }
}
