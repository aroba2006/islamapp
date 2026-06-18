import 'package:flutter/material.dart';
import 'screens/country_selection_screen.dart';

void main() {
  runApp(const IslamicApp());
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salah Times',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E3F),
          primary: const Color(0xFF1B5E3F),
          secondary: const Color(0xFFD4AF37),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B3D2E),
        fontFamily: 'Roboto',
      ),
      home: const CountrySelectionScreen(),
    );
  }
}
