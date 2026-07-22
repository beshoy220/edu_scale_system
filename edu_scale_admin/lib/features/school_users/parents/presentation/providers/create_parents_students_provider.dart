import 'package:flutter/material.dart';
import '../../data/data_sources/create_student_parent_remote_data_source.dart';

class CreateParentsStudnetsProvider extends ChangeNotifier {
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
