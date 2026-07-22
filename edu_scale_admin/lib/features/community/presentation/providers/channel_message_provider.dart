import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale_admin/features/community/data/data_sources/send_message_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../../data/data_sources/get_channel_messages_remote_data_source.dart';
import '../../data/models/channel_message_model.dart';

class ChannelMessagesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<ChannelMessageModel> messages = [];

  Future<void> getMessages({required int channelId}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      messages = await GetChannelMessagesRemoteDataSource.get(
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

  void sendMessage(int channelId, String senderId, String messageText) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Update the remote messages with the new message
      SendMessageRemoteDataSource().send(channelId, senderId, messageText);

      // Update the loacal messages with the new message
      messages.add(
        ChannelMessageModel(
          id: 0,
          channelId: channelId,
          senderId: senderId,
          senderName: SupabaseAuthService().currentUser!.userMetadata!['name'],
          senderRole: 'admin',
          attachedAssignmentId: 0,
          attachedQuizId: 0,
          messageText: messageText,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
      print(e);
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
