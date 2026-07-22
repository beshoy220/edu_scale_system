import 'package:edu_scale_admin/features/more/data/data_sources/cache/clear_all_cache_loacal_data_source.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/data_sources/remote/get_auth_remote_data_source.dart';
import '../../data/data_sources/remote/get_school_remote_data_source.dart';
import '../../data/data_sources/remote/sign_out_remote_data_source.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSchoolRemoteDataSource _getSchoolDataSource =
      GetSchoolRemoteDataSource();
  final GetAuthRemoteDataSource _getAuthDataSource = GetAuthRemoteDataSource();

  List<Map<String, dynamic>> schoolData = [];
  User? authUser;
  bool isSchoolDataLoading = false;

  /// =========================
  /// GET SCHOOL DATA
  /// =========================
  Future<void> getSchoolData() async {
    try {
      isSchoolDataLoading = true;
      notifyListeners();

      schoolData = await _getSchoolDataSource.get();
    } catch (e) {
      debugPrint('Error getting school data: $e');
      schoolData = [];
    } finally {
      isSchoolDataLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// GET AUTH USER DATA
  /// =========================
  void getAuthData() {
    authUser = _getAuthDataSource.callUserData();
    notifyListeners();
  }

  /// =========================
  /// SIGN OUT (with cache clear and navigation)
  /// =========================
  Future<void> signOut() async {
    try {
      SignOutRemoteDataSource.call();
      ClearAllCacheLoacalDataSource.clear();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
