import 'package:flutter/material.dart';
import '../../data/data_sources/get_students_remote_data_source.dart';
import '../../data/models/student_user_model.dart';

class StudentsProvider extends ChangeNotifier {
  final GetStudentsRemoteDataSource _remoteDataSource =
      GetStudentsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<StudentUserModel> students = [];

  Future<void> getStudentsByClassId({required int classId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      students = await _remoteDataSource.getStudentsByClassId(classId: classId);
    } catch (e) {
      errorMessage = e.toString();
      students = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    students = [];
    errorMessage = null;
    notifyListeners();
  }
}
