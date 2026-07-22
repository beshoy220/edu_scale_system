import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetAuthRemoteDataSource {
  User? callUserData() {
    SupabaseAuthService authService = SupabaseAuthService();
    return authService.currentUser;
  }
}
