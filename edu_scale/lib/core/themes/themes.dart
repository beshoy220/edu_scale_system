import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single entry point
abstract class AppStyle {
  static const colors = _AppColors();
  static final theme = _AppTheme().themeData;
  static final deviceSize = _DeviceSize();
}

class _AppColors {
  const _AppColors();

  final Color brown = const Color(0xFF4F3422);
  final Color onBrown = const Color(0xFF6D4A33);

  final Color yellow = const Color(0xFFFFBD19);
  final Color onYellow = const Color(0xFFFED163);

  final Color green = const Color(0xFF58CC02);
  final Color onGreen = const Color(0xFF89E219);

  final Color orange = const Color(0xFFFF7D08);
  final Color onOrange = const Color(0xFFFFAB61);

  final Color blue = const Color(0xFF1CB0F6);
  final Color onBlue = const Color(0xFF32BDFF);

  final Color red = const Color(0xFFF61C1C);
  final Color onRed = const Color(0xFFFF3232);

  final Color surface = const Color(0xFFF7F4F2);

  final Color grey = const Color(0xFFEBEBEB);
  final Color black = const Color(0xFF171717);
}

class _AppTheme {
  late final ThemeData themeData = ThemeData(
    // Text Style
    textTheme: GoogleFonts.urbanistTextTheme(), // 👈 Base text theme
    useMaterial3: true,

    primaryTextTheme: TextTheme(
      titleLarge: GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppStyle.colors.black,
      ),

      titleMedium: GoogleFonts.urbanist(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppStyle.colors.black,
      ),

      titleSmall: GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppStyle.colors.black,
      ),

      bodyLarge: GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppStyle.colors.black,
      ),

      bodyMedium: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppStyle.colors.black,
      ),

      bodySmall: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppStyle.colors.black,
      ),
    ),

    // Scaffold and AppBar Style
    appBarTheme: AppBarTheme(
      backgroundColor: AppStyle.colors.surface,
      elevation: 0,

      titleTextStyle: GoogleFonts.urbanist(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppStyle.colors.black,
      ),
    ),

    scaffoldBackgroundColor: AppStyle.colors.surface,

    // TextField Style
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppStyle.colors.black,
      ),

      hintStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppStyle.colors.black,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.black26, width: 1),
      ),

      fillColor: AppStyle.colors.grey,

      outlineBorder: BorderSide(color: AppStyle.colors.grey),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
    ),

    // Elevated Button Style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyle.colors.brown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),

        textStyle: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Drop Down Menu Style
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),

        backgroundColor: WidgetStatePropertyAll(AppStyle.colors.surface),
        elevation: const WidgetStatePropertyAll(4),
        maximumSize: WidgetStateProperty.all(const Size(200, 500)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppStyle.colors.grey,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: AppStyle.colors.grey, width: 2),
        ),
      ),
    ),

    // Snackbars Style
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

class _DeviceSize {
  Size currentDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  bool isMobile(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return true;
    } else {
      return false;
    }
  }
}
