import 'package:flutter/material.dart';
import 'screens/characters_list_page.dart';

void main() {
  runApp(const RMNApp());
}

class RMNApp extends StatelessWidget {
  const RMNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty – Galería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF10B981),
      ),
      home: const CharactersListPage(),
    );
  }
}
