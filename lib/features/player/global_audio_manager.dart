import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioManager extends GetxService {
  static GlobalAudioManager get to => Get.find();

  final AudioPlayer player = AudioPlayer();

  String? activeControllerId;
  VoidCallback? _onInterrupted;

  static Future<GlobalAudioManager> init() async {
    return Get.putAsync<GlobalAudioManager>(() async {
      return GlobalAudioManager();
    });
  }

  /// নতুন controller play করতে চাইলে আগেরটা বন্ধ হবে
  void register(String controllerId, VoidCallback onInterrupted) {
    if (activeControllerId != null && activeControllerId != controllerId) {
      _onInterrupted?.call();
    }
    activeControllerId = controllerId;
    _onInterrupted = onInterrupted;
  }

  void unregister(String controllerId) {
    if (activeControllerId == controllerId) {
      activeControllerId = null;
      _onInterrupted = null;
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}