import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/teacher/community/data/models/teacher_channel_model.dart';

class GetTeacherChannelsRemoteDataSource {
  Future<List<TeacherChannelModel>> getTeacherChannels() async {
    //1] get the schoolId and teacherId from the current user
    final currentUser = await AccountManager.currentAccount();

    // 2] get the list of channels for the teacher from the database
    SupabaseDatabaseService supabase = SupabaseDatabaseService();
    final response = await supabase.rpc(
      'get_teacher_channels',
      params: {
        'p_school_id': currentUser!.schoolId,
        'p_teacher_id': currentUser.id,
      },
    );

    //3] convert the response to a list of TeacherChannel objects
    return (response as List)
        .map((e) => TeacherChannelModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
