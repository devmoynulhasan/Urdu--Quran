import 'package:get/get.dart';

class SharedAudioState extends GetxService {
  static SharedAudioState get to => Get.find();

  var lastPlayedSurah = ''.obs;
  var lastPlayedReciter = ''.obs;
  var lastPlayedAudioUrl = ''.obs;
  var isPlayerScreenOpen = false.obs;

  void updateLastPlayed({
    required String surahName,
    required String reciterName,
    required String audioUrl,
  }) {
    lastPlayedSurah.value = surahName;
    lastPlayedReciter.value = reciterName;
    lastPlayedAudioUrl.value = audioUrl;
  }

  // ✅ এটা যোগ করো
  void clear() {
    lastPlayedSurah.value = '';
    lastPlayedReciter.value = '';
    lastPlayedAudioUrl.value = '';
  }
}