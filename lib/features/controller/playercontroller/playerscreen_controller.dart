import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/local_storage.dart';

class PlayerController extends GetxController {

  final AudioPlayer player = AudioPlayer();

  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var currentSpeed = 'x1'.obs;
  var selectedTimer = 'Never'.obs;

  final List<String> speeds = ['x 0.7', 'Normal', 'x 1.5', 'x 2'];
  final List<String> timerOptions = [
    'Never',
    '5 Minutes',
    '10 Minutes',
    '15 Minutes',
    '30 Minutes',
    '45 Minutes',
    '60 Minutes',
  ];

  Future<void> initAudio(String surahName, String reciterName) async {
    final surahNumber = surahName.split('.').first.trim();
    await player.setUrl(
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$surahNumber.mp3',
    );

    // ✅ Play শুরু হলে LocalStorage এ save করো
    await LocalStorage.saveLastPlayed(surahName, reciterName);

    player.positionStream.listen((pos) => position.value = pos);
    player.durationStream.listen((dur) => duration.value = dur ?? Duration.zero);
    player.playingStream.listen((playing) => isPlaying.value = playing);
  }

  void togglePlay() {
    if (isPlaying.value) {
      player.pause();
    } else {
      player.play();
    }
  }

  void seekTo(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  void setSpeed(String speed) {
    double speedValue = speed == 'Normal'
        ? 1.0
        : speed == 'x 0.7'
        ? 0.7
        : speed == 'x 1.5'
        ? 1.5
        : 2.0;
    player.setSpeed(speedValue);
    currentSpeed.value = speed == 'Normal' ? 'x1' : speed;
  }

  void setTimer(String timer) {
    selectedTimer.value = timer;
  }

  // ✅ Duration format helper
  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}