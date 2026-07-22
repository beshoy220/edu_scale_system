import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';

class GetSchoolStatus {
  static Future get(String email) async {
    // Get email domain
    final parts = email.split('@');
    if (parts.length != 2) throw Exception('Invalid email format');
    final domain = parts[1];

    // Get School status by domin
    SupabaseDatabaseService db = SupabaseDatabaseService();
    final response = await db
        .from('schools')
        .select()
        .eq('school_domain', domain)
        .maybeSingle(); // returns null if not found, instead of throwing

    return response;
  }
}
