import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

class UpdateTeacherAssignmentRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  /// Note that in order for this method to succes you should use
  /// (published or unpublished) in [newPublishState] param
  Future<void> updatePublishState({
    required int assignmentId,
    required String newPublishState,
  }) async {
    // 1] update pubish state
    await supabase
        .from('assignments')
        .update({'publish_status': newPublishState})
        .eq('id', assignmentId);
  }
}
