import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:urdu_quran/core/device_id.dart';

import 'features/player/global_audio_manager.dart';
import 'features/player/shared_audio_satatus.dart';
import 'features/splash/splashscreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async => SharedAudioState());
  await GlobalAudioManager.init();
  await GetStorage.init();

  // ✅ Device ID print
  final deviceId = await DeviceId.getId();
  print('🔑 Device ID: $deviceId');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urdu Quran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Splashscreen(),
    );
  }
}