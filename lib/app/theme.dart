import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core color palette
  // 212832 - page bg color
  // 455A64 - input field bg color
  // 8CAAB9 - text dark color
  // FFFFFF - text white color
  // 000000 - text black color
  // FED36A - button bg / app yellow
  // FF5252 - error red

  // Main colors
  static const Color pageBgColor = Color(0xFF212832); // Page background color
  static const Color inputFieldBgColor = Color(
    0xFF455A64,
  ); // Input field background color
  static const Color textDarkColor = Color(
    0xFF8CAAB9,
  ); // Text dark color (also for secondary text)
  static const Color textWhiteColor = Color(0xFFFFFFFF); // Text white color
  static const Color textBlackColor = Color(0xFF000000); // Text black color
  static const Color buttonBgColor = Color(
    0xFFFED36A,
  ); // Button background / app yellow
  static const Color errorColor = Color(
    0xFFFF5252,
  ); // Standard red for error states

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily, // Inter font for all pages
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: buttonBgColor, // FED36A - button bg / app yellow
        onPrimary: textBlackColor, // 000000 - black text on yellow
        secondary: buttonBgColor, // Use button color for secondary
        onSecondary: textBlackColor, // 000000 - black text
        tertiary: buttonBgColor, // Use button color for tertiary
        onTertiary: textBlackColor, // 000000 - black text
        error: errorColor, // FF5252 - red for errors
        onError: textWhiteColor, // FFFFFF - white text on error
        surface: textWhiteColor, // FFFFFF - white surfaces
        onSurface: textBlackColor, // 000000 - black text on white
        background: pageBgColor, // 212832 - page background
        onBackground: textWhiteColor, // FFFFFF - white text
      ),
      scaffoldBackgroundColor: pageBgColor, // 212832 - page background
      appBarTheme: AppBarTheme(
        backgroundColor: pageBgColor, // 212832 - page background
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: textWhiteColor,
        ), // FFFFFF - white icons
        titleTextStyle: GoogleFonts.inter(
          color: textWhiteColor, // FFFFFF - white text
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: textWhiteColor, // FFFFFF - white text
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: textDarkColor, // 8CAAB9 - text dark color for secondary text
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: textDarkColor, // 8CAAB9 - text dark color for secondary text
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFieldBgColor, // 455A64 - input field background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: textDarkColor,
          ), // 8CAAB9 - text dark color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: textDarkColor,
          ), // 8CAAB9 - text dark color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: buttonBgColor,
            width: 2,
          ), // FED36A - button bg / app yellow
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor), // FF5252 - red
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ), // FF5252 - red
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBgColor, // FED36A - button bg / app yellow
          foregroundColor: textBlackColor, // 000000 - black text
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textBlackColor, // 000000 - black text
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: buttonBgColor, // FED36A - button bg / app yellow
        foregroundColor: textBlackColor, // 000000 - black icon
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: textWhiteColor, // FFFFFF - white
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: textDarkColor,
            width: 1,
          ), // 8CAAB9 - text dark color
        ),
      ),
    );
  }
}
