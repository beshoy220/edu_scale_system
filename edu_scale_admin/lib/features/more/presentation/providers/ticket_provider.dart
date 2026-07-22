import 'package:flutter/material.dart';

import '../../data/models/support_ticket_model.dart';
import '../../data/data_sources/remote/get_support_ticket_remote_data_source.dart';

class SupportTicketsProvider extends ChangeNotifier {
  final GetSupportTicketsRemoteDataSource _repository =
      GetSupportTicketsRemoteDataSource();

  List<SupportTicket> tickets = [];

  bool isLoading = false;
  bool hasMore = true;

  String? error;

  static const int pageSize = 20;

  int _from = 0;

  Future<void> fetchTickets() async {
    if (isLoading || !hasMore) return;

    try {
      isLoading = true;
      error = null;

      notifyListeners();

      final result = await _repository.getSupportTickets(
        from: _from,
        to: _from + pageSize - 1,
      );

      tickets.addAll(result);

      _from += pageSize;

      if (result.length < pageSize) {
        hasMore = false;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    tickets.clear();

    _from = 0;
    hasMore = true;
    error = null;

    await fetchTickets();
  }
}
