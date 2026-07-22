import 'package:flutter/material.dart';
import '../../../../core/app_meta/view_state_enum.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/use_cases/get_template_use_case.dart';

class TemplateProvider extends ChangeNotifier {
  final GetTemplateUseCase getTemplates;

  TemplateProvider(this.getTemplates);

  List<TemplateEntity> items = [];

  ViewState state = ViewState.idle;
  String? error;

  Future<void> fetch() async {
    _setState(ViewState.loading);

    try {
      final result = await getTemplates();

      if (result.isEmpty) {
        items = [];
        _setState(ViewState.empty);
        return;
      }

      items = result;
      _setState(ViewState.success);
    } catch (e) {
      error = e.toString();
      _setState(ViewState.error);
    }
  }

  void _setState(ViewState newState) {
    state = newState;
    notifyListeners();
  }
}
