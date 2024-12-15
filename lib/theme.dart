import 'package:flutter/material.dart';

ThemeData buildThemeData() {
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        textStyle: TextStyle(
          fontSize: 18,  // Set the text size to 18
          color: Colors.black, // Optional: Set the text color
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white, // Background color
      hintStyle: TextStyle(color: Colors.grey), // Hint text color
      prefixIconColor: Colors.grey, // Prefix icon color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        borderSide: BorderSide.none, // No border line
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black, // Set a consistent cursor color
    ),
  );
}
