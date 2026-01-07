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
    // Light theme colors - inverted from dark theme
    // Background colors: dark → light
    const Color lightPageBgColor = Color(
      0xFFFFFFFF,
    ); // White background (inverted from dark)
    const Color lightInputFieldBgColor = Color(
      0xFFE5E5E5,
    ); // Light gray (inverted from dark gray)
    // Text colors: white → black, black → white
    const Color lightTextDarkColor = Color(
      0xFF4A5568,
    ); // Darker gray for secondary text (inverted from light blue-gray)
    const Color lightTextWhiteColor = Color(
      0xFF000000,
    ); // Black text (inverted from white)
    const Color lightTextBlackColor = Color(
      0xFFFFFFFF,
    ); // White text (inverted from black)
    // Keep accent colors the same
    const Color lightButtonBgColor = Color(0xFFFED36A); // Keep yellow
    const Color lightErrorColor = Color(0xFFFF5252); // Keep red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: lightButtonBgColor,
        onPrimary: lightTextBlackColor, // White text on yellow
        secondary: lightButtonBgColor,
        onSecondary: lightTextBlackColor,
        tertiary: lightButtonBgColor,
        onTertiary: lightTextBlackColor,
        error: lightErrorColor,
        onError: lightTextWhiteColor, // Black text on red
        surface: lightInputFieldBgColor,
        onSurface: lightTextWhiteColor, // Black text
        background: lightPageBgColor,
        onBackground: lightTextWhiteColor, // Black text
      ),
      scaffoldBackgroundColor: lightPageBgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: lightPageBgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: lightTextWhiteColor, // Black icons
        ),
        titleTextStyle: GoogleFonts.inter(
          color: lightTextWhiteColor, // Black text
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: lightTextWhiteColor, // Black text
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: lightTextDarkColor, // Dark gray for secondary text
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: lightTextDarkColor, // Dark gray for secondary text
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputFieldBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightTextDarkColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightTextDarkColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightButtonBgColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightErrorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightErrorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightButtonBgColor,
          foregroundColor: lightTextBlackColor, // White text on yellow
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: lightTextBlackColor, // White text
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightButtonBgColor,
        foregroundColor: lightTextBlackColor, // White icon
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: lightInputFieldBgColor, // Light gray
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightTextDarkColor, width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Dark theme colors - using original dark colors (default theme)
    // These are the original colors from the app design
    const Color darkPageBgColor =
        pageBgColor; // 0xFF212832 - original dark background
    const Color darkInputFieldBgColor =
        inputFieldBgColor; // 0xFF455A64 - original input field color
    const Color darkTextDarkColor =
        textDarkColor; // 0xFF8CAAB9 - original text dark color
    const Color darkTextWhiteColor =
        textWhiteColor; // 0xFFFFFFFF - original white text
    const Color darkTextBlackColor =
        textBlackColor; // 0xFF000000 - original black text
    const Color darkButtonBgColor =
        buttonBgColor; // 0xFFFED36A - original yellow
    const Color darkErrorColor = errorColor; // 0xFFFF5252 - original red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: darkButtonBgColor,
        onPrimary: darkTextBlackColor,
        secondary: darkButtonBgColor,
        onSecondary: darkTextBlackColor,
        tertiary: darkButtonBgColor,
        onTertiary: darkTextBlackColor,
        error: darkErrorColor,
        onError: darkTextWhiteColor,
        surface: darkInputFieldBgColor,
        onSurface: darkTextWhiteColor,
        background: darkPageBgColor,
        onBackground: darkTextWhiteColor,
      ),
      scaffoldBackgroundColor: darkPageBgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkPageBgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkTextWhiteColor),
        titleTextStyle: GoogleFonts.inter(
          color: darkTextWhiteColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: darkTextWhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: darkTextDarkColor,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: darkTextDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputFieldBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkTextDarkColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkTextDarkColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkButtonBgColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkErrorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkErrorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkButtonBgColor,
          foregroundColor: darkTextBlackColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkTextBlackColor,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkButtonBgColor,
        foregroundColor: darkTextBlackColor,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: darkInputFieldBgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkTextDarkColor, width: 1),
        ),
      ),
    );
  }
}
