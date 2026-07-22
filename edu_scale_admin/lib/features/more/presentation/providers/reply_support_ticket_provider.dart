import 'package:flutter/material.dart';

import '../../data/data_sources/remote/reply_support_ticket_remote_data_source.dart';

class ReplySupportTicketProvider extends ChangeNotifier {
  final ReplySupportTicketRemoteDataSource _remoteDataSource =
      ReplySupportTicketRemoteDataSource();

  bool isLoading = false;

  String? errorMessage;

  Future<bool> reply({
    required int supportTicketId,
    required String reply,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      await _remoteDataSource.replyToTicket(
        supportTicketId: supportTicketId,
        reply: reply,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    errorMessage = null;
    notifyListeners();
  }
}
