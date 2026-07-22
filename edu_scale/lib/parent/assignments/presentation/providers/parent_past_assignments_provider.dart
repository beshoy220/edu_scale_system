import 'package:edu_scale/parent/assignments/data/data_sources/get_parent_past_assignemnts_remote_data_source.dart';
import 'package:edu_scale/parent/assignments/data/models/parent_past_assignment_model.dart';
import 'package:flutter/material.dart';

class ParentPastAssignmentsProvider extends ChangeNotifier {
  final GetParentPastAssignmentsRemoteDataSource _dataSource =
      GetParentPastAssignmentsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<ParentPastAssignmentModel> pastAssignmentsList = [];

  Future<void> getPastAssignments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pastAssignmentsList = await _dataSource.getLast150PastAssignments();
    } catch (e) {
      errorMessage = e.toString();
      pastAssignmentsList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    pastAssignmentsList = [];
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
