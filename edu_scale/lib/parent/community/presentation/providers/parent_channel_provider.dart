import 'package:flutter/material.dart';
import 'package:edu_scale/parent/community/data/data_sources/get_parent_channels_remote_data_source.dart';
import 'package:edu_scale/parent/community/data/models/parent_channel_model.dart';

class ParentChannelsProvider extends ChangeNotifier {
  final GetParentChannelsRemoteDataSource _dataSource =
      GetParentChannelsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<ParentChannelModel> channels = [];

  Future<void> getChannels() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      channels = await _dataSource.getParentChannels();
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
