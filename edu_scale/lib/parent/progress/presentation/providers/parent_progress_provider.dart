import 'package:edu_scale/parent/progress/data/data_sources/get_parent_progress_remote_data_source.dart';
import 'package:edu_scale/parent/progress/data/models/parent_progress_model.dart';
import 'package:flutter/material.dart';

class ParentProgressProvider extends ChangeNotifier {
  final GetParentProgressRemoteDataSource _remoteDataSource =
      GetParentProgressRemoteDataSource();

  bool _isLoading = false;
  String? _errorMessage;
  ParentProgressModel? _progress;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ParentProgressModel? get progress => _progress;

  Future<void> getProgress() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _progress = await _remoteDataSource.getProgress();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearProgress() {
    _progress = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _progress = null;
    notifyListeners();
  }
}
