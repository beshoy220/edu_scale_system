import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';

class SignOutRemoteDataSource {
  Future<void> signOut() async {
    SupabaseAuthService auth = SupabaseAuthService();
    auth.signOut();
  }
}
