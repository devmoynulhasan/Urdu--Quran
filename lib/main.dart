import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/home/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // ✅ MaterialApp → GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Urdu Quran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}