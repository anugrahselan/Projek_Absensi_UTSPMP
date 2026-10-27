import 'package:flutter/material.dart';

class AppTheme {
  // Warna Utama
  static const Color primaryColor = Color(0xFF2962FF); // Royal Blue
  static const Color primaryLight = Color(0xFFE8EAF6);
  static const Color scaffoldBackground = Color(0xFFF7F9FC);
  static const Color cardBackground = Colors.white;

  // Warna Status Badge (Sesuai Referensi UI pmpl_003-005)
  static const Color hadirBg = Color(0xFFE8F5E9);
  static const Color hadirText = Color(0xFF2E7D32);

  static const Color sakitBg = Color(0xFFFFEBEE);
  static const Color sakitText = Color(0xFFC62828);

  static const Color izinBg = Color(0xFFFFF8E1);
  static const Color izinText = Color(0xFFF57F17);

  static const Color alpaBg = Color(0xFFEDE7F6);
  static const Color alpaText = Color(0xFF5E35B1);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E293B),
        elevation: 0.5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 1,
        shadowColor: const Color(0x0A000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }
}
