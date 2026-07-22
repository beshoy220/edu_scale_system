import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/teacher/attendance/data/models/teacher_attendace_student_model.dart';
import 'package:edu_scale/teacher/attendance/data/models/teacher_attendance_classes_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherAttendanceRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<TeacherAttendanceClassesListModel>> getClassesBySchoolId() async {
    // 1] get school id
    final currentUser = await AccountManager.currentAccount();
    final schoolId = currentUser!.schoolId;

    // 2] query classes list
    final response = await _supabase
        .from('classes')
        .select('''
          id,
          nickname,
          grade_id,
          grades!inner(
            name
          )
        ''')
        .eq('school_id', schoolId)
        .order('grade_id')
        .order('nickname');

    // 3] model response
    return (response as List)
        .map(
          (e) => TeacherAttendanceClassesListModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<TeacherAttendanceStudentModel>> getStudentsAttendanceByClassId({
    required int classId,
  }) async {
    // 1] query classes list
    final response = await _supabase.rpc(
      'get_class_students_attendance',
      params: {
        'p_class_id': classId,
        'p_date': DateTime.now().toIso8601String().split('T').first,
      },
    );

    // 2] model response
    return (response as List)
        .map(
          (e) =>
              TeacherAttendanceStudentModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveAttendance(
    int gradeId,
    int classId,
    List<TeacherAttendanceStudentModel> modifiedStudents,
  ) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final currentUser = await AccountManager.currentAccount();
    final schoolId = currentUser!.schoolId;
    final teacherId = currentUser.id;

    for (final student in modifiedStudents) {
      if (student.attendanceId == null) {
        await _supabase.from('attendance').insert({
          'school_id': schoolId,
          'grade_id': gradeId,
          'class_id': classId,
          'student_id': student.studentId,
          'taken_by': teacherId,
          'attendance_date': today,
          'status': student.attendanceStatus,
          'reason': student.attendanceReason,
        });
      } else {
        await _supabase
            .from('attendance')
            .update({
              'status': student.attendanceStatus,
              'reason': student.attendanceReason,
            })
            .eq('id', student.attendanceId!);
      }
    }
  }
}
