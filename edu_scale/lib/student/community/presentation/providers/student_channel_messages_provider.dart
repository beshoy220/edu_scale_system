import 'package:edu_scale/student/community/data/data_sources/get_student_channel_messages_remote_data_source.dart';
import 'package:edu_scale/student/community/data/models/student_channel_message_model.dart';
import 'package:flutter/material.dart';

class StudentChannelMessagesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<StudentChannelMessageModel> messages = const [];

  Future<void> loadMessages({required int channelId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      messages =
          await GetStudentChannelMessagesRemoteDataSource.getLast100Messages(
            channelId: channelId,
          );
    } catch (e) {
      errorMessage = e.toString();
      messages = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    messages = [];
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
