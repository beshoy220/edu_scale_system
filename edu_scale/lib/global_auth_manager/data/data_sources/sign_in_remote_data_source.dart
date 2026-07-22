import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRemoteDataSource {
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    SupabaseAuthService auth = SupabaseAuthService();
    return auth.signIn(email: email, password: password);
  }
}
