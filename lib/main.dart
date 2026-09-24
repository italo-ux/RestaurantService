import 'package:flutter/material.dart';

import 'screens/lojas_screen.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF276749);
    return MaterialApp(
      title: 'Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: verde),
        scaffoldBackgroundColor: const Color(0xFFF6F7F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7F3),
          foregroundColor: Color(0xFF1F2933),
          centerTitle: false,
        ),
      ),
      home: const LojasScreen(),
    );
  }
}
