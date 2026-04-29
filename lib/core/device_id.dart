import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceId {
  static String? _cachedId;

  static Future<String> getId() async {
    if (_cachedId != null) {
      print('✅ Cached Device ID: $_cachedId');
      return _cachedId!;
    }

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      _cachedId = android.id;
      print('📱 Android Device ID: $_cachedId');
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      _cachedId = ios.identifierForVendor ?? 'unknown-ios';
      print('🍎 iOS Device ID: $_cachedId');
    } else {
      print('❌ Unsupported platform');
    }

    return _cachedId!;
  }
}