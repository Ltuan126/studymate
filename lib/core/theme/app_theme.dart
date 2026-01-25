import 'package:flutter/material.dart';

/// Màu sắc chính của ứng dụng - Sử dụng thống nhất trong toàn bộ app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4D47E5);
  static const Color primaryDark = Color(0xFF4B42D6);
  static const Color primaryLight = Color(0xFF6347E5);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFFB74D);

  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundGrey = Color(0xFFF6F6F8);
  static const Color cardGrey = Color(0xFFE1E1E4);
  static const Color fieldBackground = Color(0xFFF5F5F7);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF7C7C86);
  static const Color textHint = Color(0xFFD6D6DC);

  // Border Colors
  static const Color border = Color(0xFFD6D6DC);

  // Avatar/Profile Colors
  static const Color avatarPink = Color(0xFFFFB2B2);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true);
}
