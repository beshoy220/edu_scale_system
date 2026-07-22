import 'package:edu_scale/teacher/community/data/data_sources/get_teacher_channels_remote_data_source.dart';
import 'package:edu_scale/teacher/community/data/models/teacher_channel_model.dart';
import 'package:flutter/material.dart';

class TeacherChannelsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<TeacherChannelModel> channels = const [];

  Future<void> loadChannels() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      channels = await GetTeacherChannelsRemoteDataSource()
          .getTeacherChannels();
    } catch (e) {
      errorMessage = e.toString();
      channels = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearChannels() {
    channels = [];
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
