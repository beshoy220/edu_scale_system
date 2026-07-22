import 'package:edu_scale/parent/home_base/data/data_sources/get_student_info_for_parent_remote_data_source.dart';
import 'package:edu_scale/parent/home_base/data/models/parent_student_info_model.dart';
import 'package:flutter/foundation.dart';

class ParentStudentInfoProvider extends ChangeNotifier {
  final GetStudentInfoForParentRemoteDataSource _dataSource =
      GetStudentInfoForParentRemoteDataSource();

  ParentStudentInfoModel? student;

  bool isLoading = false;
  String? errorMessage;

  Future<void> getStudentInfoByStudentId(String studentId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      student = await _dataSource.getStudentInfoByStudentId(studentId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    student = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
