// lib/core/audio_session_manager.dart

class AudioSessionManager {
  static Function? _stopCurrent;

  // ✅ নতুন audio শুরু হলে আগেরটা বন্ধ
  static void register(Function stopCallback) {
    _stopCurrent?.call(); // আগেরটা বন্ধ
    _stopCurrent = stopCallback; // নতুনটা register
  }

  static void unregister() {
    _stopCurrent = null;
  }
}