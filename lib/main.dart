// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(const WallpaperDribbbleApp());
}

class WallpaperDribbbleApp extends StatelessWidget {
  const WallpaperDribbbleApp({super.key});
  @override
  Widget build(BuildContext context) {
    final seed = Colors.purple;
    return MaterialApp(
      title: 'DribbleWalls',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0B0C10),
        cardColor: const Color(0xFF101216),
        textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'Inter')),
      ),
      home: const HomePage(),
    );
  }
}
