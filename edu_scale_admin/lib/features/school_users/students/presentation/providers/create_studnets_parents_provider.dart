import 'package:flutter/material.dart';
import '../../data/data_sources/create_student_parent_remote_data_source.dart';

class CreateStudnetsParentsProvider extends ChangeNotifier {
  Future<void> createUsers({
    required int gradeId,
    required int classId,
    required List<Map<String, String>> users,
  }) async {
    final CreateStudentParentRemoteDataSource remoteDataSource =
        CreateStudentParentRemoteDataSource();

    await remoteDataSource.create(
      gradeId: gradeId,
      classId: classId,
      users: users,
    );
  }
}

// Users Example:
//
// [
//     {
//       'student_name': 'Amar Ahmed',
//       'parent_name': 'Ahmed Sayed',
//       'parent_phone': '201239123938',
//     },
//     {
//       'student_name': 'Marina Nashed',
//       'parent_name': 'Mark Michael',
//       'parent_phone': '201239123938',
//     },
//   ],
