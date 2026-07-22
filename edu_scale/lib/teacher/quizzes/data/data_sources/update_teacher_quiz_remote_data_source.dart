import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

class UpdateTeacherQuizRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  /// Note that in order for this method to succes you should use
  /// (published or unpublished) in [newPublishState] param
  Future<void> updatePublishState({
    required int quizId,
    required String newPublishState,
  }) async {
    // 1] update pubish state
    await supabase
        .from('quizzes')
        .update({'publish_status': newPublishState})
        .eq('id', quizId);
  }
}
