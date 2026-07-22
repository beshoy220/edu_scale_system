import 'package:flutter/material.dart';

import '../../../../../core/themes/themes.dart';

class CustomGreyElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomGreyElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyle.colors.grey,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppStyle.theme.textTheme.bodySmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
