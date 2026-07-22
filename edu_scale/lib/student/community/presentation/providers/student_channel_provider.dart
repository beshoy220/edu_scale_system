import 'package:flutter/material.dart';
import 'package:edu_scale/student/community/data/data_sources/get_student_channels_remote_data_source.dart';
import 'package:edu_scale/student/community/data/models/student_channel_model.dart';

class StudentChannelsProvider extends ChangeNotifier {
  final GetStudentChannelsRemoteDataSource _dataSource =
      GetStudentChannelsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<StudentChannelModel> channels = [];

  Future<void> getChannels() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      channels = await _dataSource.getStudentChannels();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await getChannels();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void clearChannels() {
    channels = [];
    notifyListeners();
  }
}
