import 'package:flutter/material.dart';

/// A widget that builds different layouts based on the screen size.
/// It takes three widgets as parameters: [small], [medium], and an optional [large].
/// The layout is determined by the width of the screen:
/// - small: width < 600
/// - medium: 600 <= width < 1024
/// - large: width >= 1024
/// If the [large] widget is not provided, the [medium] layout will be used for large screens as well.
///
/// Example usage:
/// ```dart
/// ResponsiveLayoutBuilder(
///   small: Scaffold(body: Text('I am a small screen')),
///   medium: Scaffold(body: Text('I am a medium screen')),
///   large: Scaffold(body: Text('I am a large screen')),
/// );
/// ```
/// This widget is useful for creating responsive designs that adapt to different screen sizes without having to write separate code for each layout.

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget small;
  final Widget medium;
  final Widget? large;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.small,
    required this.medium,
    this.large,
  });

  static const double smallBreakpoint = 600;
  static const double mediumBreakpoint = 1024;

  static DeviceType getDeviceType(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width < smallBreakpoint) {
      return DeviceType.small;
    } else if (width < mediumBreakpoint) {
      return DeviceType.medium;
    } else {
      return DeviceType.large;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    if (deviceType == DeviceType.small) {
      return small;
    } else if (deviceType == DeviceType.medium || large == null) {
      return medium;
    } else if (deviceType == DeviceType.large && large != null) {
      return large!;
    } else {
      // This case should never happen, but we return an error widget just in case
      return Text(
        'Error: No Layout widget have been selected',
        style: TextStyle(color: Colors.red, fontSize: 18),
      );
    }
  }
}

enum DeviceType { small, medium, large }
