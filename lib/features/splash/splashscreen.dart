import 'package:flutter/material.dart';
import 'package:urdu_quran/features/home/homescreen.dart';
import '../../resource/app_images/app_imaeg.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
    // অথবা:
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const HomeScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D00F6), // ✅ ঠিক করা হয়েছে
          image: DecorationImage(
            image: AssetImage(AssetPaths.splash_image_one),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}