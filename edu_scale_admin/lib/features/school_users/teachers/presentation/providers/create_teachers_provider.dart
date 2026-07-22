import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/data_sources/create_teachers_remote_data_source.dart';

class CreateTeachersProvider extends ChangeNotifier {
  final CreateTeachersRemoteDataSource _remoteDataSource =
      CreateTeachersRemoteDataSource();

  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;
  List createdUsers = [];
  List failedUsers = [];

  Future<void> createUsers(
    int subjectId,
    String subjectName,
    List<Map> usersList, // List of {'teacher_name': 'name', 'teacher_phone':''}
  ) async {
    try {
      isLoading = true;
      isSuccess = false;
      errorMessage = null;
      createdUsers = [];
      failedUsers = [];
      notifyListeners();

      final FunctionResponse response = await _remoteDataSource.create(
        subjectId,
        subjectName,
        usersList,
      );

      final data = response.data;
      isSuccess = data['success'] ?? false;
      createdUsers = data['success_users'] ?? [];
      failedUsers = data['failed_users'] ?? [];
      errorMessage = data['message'];
    } catch (e) {
      errorMessage = e.toString();
      isSuccess = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
