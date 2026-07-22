import 'package:edu_scale/parent/community/data/data_sources/get_parent_channel_messages_remote_data_source.dart';
import 'package:edu_scale/parent/community/data/models/parent_channel_message_model.dart';
import 'package:flutter/material.dart';

class ParentChannelMessagesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<ParentChannelMessageModel> messages = const [];

  Future<void> loadMessages({required int channelId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      messages =
          await GetParentChannelMessagesRemoteDataSource.getLast100Messages(
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
