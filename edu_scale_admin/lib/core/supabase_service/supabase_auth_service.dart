import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class SupabaseAuthService {
  final _client = SupabaseConfig.client;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
