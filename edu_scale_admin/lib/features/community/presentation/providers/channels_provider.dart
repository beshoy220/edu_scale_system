import 'package:flutter/material.dart';
import '../../data/data_sources/get_channels_remote_data_source.dart';
import '../../data/models/channel_model.dart';

class ChannelsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<ChannelModel> channels = [];

  Future<void> getChannels() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      channels = await GetChannelsRemoteDataSource.get();
    } catch (e) {
      errorMessage = e.toString();
      channels = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await getChannels();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
