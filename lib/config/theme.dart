import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Get the shadcn Slate theme data
ShadThemeData getShadThemeData() {
  return ShadThemeData(
    colorScheme: const ShadSlateColorScheme.light(),
    brightness: Brightness.light,
  );
}

ThemeData buildThemeData() {
  // Get shadcn slate theme colors
  final shadColors = const ShadSlateColorScheme.light();

  return ThemeData(
    // Use shadcn color scheme as base
    colorScheme: ColorScheme.light(
      primary: shadColors.primary,
      secondary: shadColors.secondary,
      surface: shadColors.background,
      error: shadColors.destructive,
    ),

    // Modern, clean font
    fontFamily: 'Inter',

    // Updated button theme with Typesense-style hard shadows
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: shadColors.primary,
        foregroundColor: shadColors.primaryForeground,
        elevation: 0, // No soft shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Super rounded
          // No border - clean button face
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ).copyWith(
        // No hover color change - just show hand cursor
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return shadColors.primary; // Same color always
        }),
      ),
    ),

    // Clean input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: shadColors.background,
      hintStyle: TextStyle(color: shadColors.mutedForeground),
      prefixIconColor: shadColors.mutedForeground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: shadColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: shadColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: shadColors.border, width: 1), // Same as enabled border
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: shadColors.primary,
    ),

    // Card theme for clean cards
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: shadColors.border),
      ),
      color: shadColors.card,
    ),

    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: shadColors.background,
      foregroundColor: shadColors.foreground,
      centerTitle: true,
    ),
  );
}
