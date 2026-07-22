import 'package:flutter/material.dart';
import '../../app_meta/view_state_enum.dart';

/// A widget that builds different UI based on the [ViewState].
/// It handles loading, error, empty, and success states, allowing you to easily
/// manage the UI for each state in a clean and reusable way.
/// [onSuccess] is a callback that returns the widget to display when the state is [ViewState.success].
/// [onEmpty] is a callback that returns the widget to display when the state is [ViewState.empty].
/// [onRetry] is a callback that is called when the user taps the retry button in the error state.
///
/// Example usage:
/// ```dart
/// CustomStateBuilder(
///   state: provider.state,
///   error: provider.error,
///   onSuccess: () => YourSuccessWidget(),
///   onEmpty: () => YourEmptyWidget(),
///   onRetry: () => provider.fetch(),
/// );
/// ```
///
/// This widget simplifies the process of handling different states in your UI,
/// making it easier to maintain and read.
///
class CustomStateBuilder extends StatelessWidget {
  final ViewState state;
  final String? error;

  final Widget Function()? onSuccess;
  final Widget Function()? onEmpty;
  final VoidCallback? onRetry;

  const CustomStateBuilder({
    super.key,
    required this.state,
    this.error,
    this.onSuccess,
    this.onEmpty,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error ?? "Opss! Something went wrong!"),
              ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
            ],
          ),
        );

      case ViewState.empty:
        return onEmpty?.call() ?? const Center(child: Text("No data"));

      case ViewState.success:
        return onSuccess?.call() ?? const SizedBox();

      case ViewState.idle:
        return const SizedBox();
    }
  }
}
