import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignIn {
  Future<AuthResponse> call(String email, String password) async {
    SupabaseAuthService auth = SupabaseAuthService();
    return auth.signIn(email: email, password: password);
  }
}
