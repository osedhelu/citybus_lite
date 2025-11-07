import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7);
// const seedColor = Color.fromARGB(255, 7, 80, 59);

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorSeed,
    textTheme: TextTheme(
      // Títulos
      titleLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.montserratAlternates().copyWith(fontSize: 20),

      // Textos del cuerpo - REDUCIDOS GLOBALMENTE
      bodyLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 12,
      ), // Reducido de 14 a 12
      bodyMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 10,
      ), // Reducido de 12 a 10
      bodySmall: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 9,
      ), // Reducido de 10 a 9
      // Etiquetas y texto pequeño
      labelLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 10,
      ), // Reducido de 12 a 10
      labelMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 9,
      ), // Reducido de 10 a 9
      labelSmall: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 8,
      ), // Reducido de 9 a 8
      // Headlines
      headlineLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ), // Reducido de 32
      headlineMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ), // Reducido de 28
      headlineSmall: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ), // Reducido de 24
      // Display text
      displayLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 52,
        fontWeight: FontWeight.bold,
      ), // Reducido de 57
      displayMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ), // Reducido de 45
      displaySmall: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ), // Reducido de 36
    ),

    brightness: isDarkmode ? Brightness.dark : Brightness.light,
    listTileTheme: const ListTileThemeData(iconColor: colorSeed),

    ///* AppBar
    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    ///* Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.montserratAlternates().copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}
