import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF2962FF), // Electric blue
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212), // OLED true black

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E), // Darker than scaffold
        foregroundColor: Color(0xFFE0E0E0), // Light grey text
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFE0E0E0),
        ),
      ),

      // Card Theme
      cardTheme: const CardTheme(
        elevation: 8,
        color: Color(0xFF1E1E1E), // Dark grey cards
        shadowColor: Color(0xFF000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2979FF), // Bright electric blue
          foregroundColor: Colors.white,
          shadowColor: const Color(0xFF0D47A1).withOpacity(0.5),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C), // Dark input fields
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        labelStyle: const TextStyle(color: Color(0xFFB0BEC5)),
      ),

      // Bottom Navigation Bar Theme
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF64B5F6), // Lighter blue for selected items
        unselectedItemColor: Color(0xFF757575), // Medium grey for unselected
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Color(0xFF1F1F1F), // Slightly different from card color
        elevation: 12, // Higher elevation for more depth
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color(0xFF64B5F6),
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color(0xFF757575),
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w300),
        displayMedium:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        displaySmall:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        headlineMedium:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        headlineSmall:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        titleLarge:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
        titleMedium:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w400),
        bodyMedium:
            TextStyle(color: Color(0xFFB0BEC5), fontWeight: FontWeight.w400),
        bodySmall:
            TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w400),
        labelLarge:
            TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
        labelMedium:
            TextStyle(color: Color(0xFFB0BEC5), fontWeight: FontWeight.w500),
        labelSmall:
            TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: Color(0xFF2979FF),
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 0.5,
      ),

      // Snack Bar Theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF323232),
        contentTextStyle: TextStyle(color: Color(0xFFE0E0E0)),
        actionTextColor: Color(0xFF2979FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Dialog Theme
      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFF1E1E1E),
        titleTextStyle: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: Color(0xFFB0BEC5),
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: CircleBorder(),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF2979FF);
          }
          return const Color(0xFF9E9E9E);
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF2979FF).withOpacity(0.5);
          }
          return const Color(0xFF424242);
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF2979FF);
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: Color(0xFF9E9E9E), width: 2),
      ),

      // Chip Theme
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFF2C2C2C),
        disabledColor: Color(0xFF424242),
        selectedColor: Color(0xFF2979FF),
        secondarySelectedColor: Color(0xFF1976D2),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        brightness: Brightness.dark,
        elevation: 2,
        pressElevation: 4,
      ),
    );
  }
}
