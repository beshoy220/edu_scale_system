import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';

class GetSchoolRemoteDataSource {
  Future<List<Map<String, dynamic>>> get() async {
    // 1. Get school_id from cache
    final schoolDomainString = await CachedResources.getSchoolDomain();

    if (schoolDomainString == null) {
      throw Exception('School ID not found in cache.');
    }

    // 2. get
    final SupabaseDatabaseService db = SupabaseDatabaseService();

    var res = await db
        .from('schools')
        .select()
        .eq('school_domain', schoolDomainString)
        .select();
    return res;
  }
}
