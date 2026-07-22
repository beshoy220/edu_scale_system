import 'package:flutter/material.dart';

class DashBoardIndexProvider extends ChangeNotifier {
  int index = 0;

  void setIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }
}
