import 'package:get/get.dart';

class FavoritesController extends GetxController {

  var playingIndex = RxnInt(); // null হতে পারে

  final RxList<String> favorites = [
    '1. Al-Baqarah',
    '2. Al-Fatihah',
    '2. Al-Fatihah',
    '1. Al-Baqarah',
    '2. Al-Fatihah',
    '2. Al-Fatihah',
    '2. Al-Fatihah',
    '2. Al-Fatihah',
    '2. Al-Fatihah',
  ].obs;

  void togglePlay(int index) {
    if (playingIndex.value == index) {
      playingIndex.value = null;
    } else {
      playingIndex.value = index;
    }
  }

  bool isPlaying(int index) => playingIndex.value == index;
}