import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';

class SignOutRemoteDataSource {
  static void call() {
    SupabaseAuthService auth = SupabaseAuthService();
    auth.signOut();
  }
}
