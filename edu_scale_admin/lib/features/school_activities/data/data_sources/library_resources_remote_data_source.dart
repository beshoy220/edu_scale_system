import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/library_item_model.dart';

class LibraryResourcesRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<List<LibraryItemModel>> getLibraryResources({
    required int from,
    required int to,
  }) async {
    final schoolIdString = await CachedResources.getSchoolId();

    if (schoolIdString == null) {
      throw Exception('School ID not found.');
    }

    final schoolId = int.tryParse(schoolIdString);

    if (schoolId == null) {
      throw Exception('Invalid school ID.');
    }

    final response = await _supabase
        .from('library_resources')
        .select('''
          id,
          title,
          file_url,
          file_size_in_kb,
          file_type,
          status,
          created_at,
          subjects(name),
          grades(name),
          classes(nickname),
          users(name)
        ''')
        .eq('school_id', schoolId)
        .order('created_at', ascending: false)
        .range(from, to);

    return LibraryItemModel.fromJsonList(response);
  }

  Future<void> updateResourceStatus({
    required int resourceId,
    required String status,
  }) async {
    await _supabase
        .from('library_resources')
        .update({'status': status})
        .eq('id', resourceId);
  }
}
