import 'package:flutter/material.dart';

class Themes {
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          selectedIconTheme: const IconThemeData(color: Colors.teal),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedLabelStyle: const TextStyle(fontSize: 12)),
      appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          iconTheme: const IconThemeData(color: Colors.black)),
      listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20)));

  static ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        selectedIconTheme: const IconThemeData(color: Colors.teal),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedLabelStyle: const TextStyle(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
          iconTheme: const IconThemeData(color: Colors.white)),
      listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)));
}
