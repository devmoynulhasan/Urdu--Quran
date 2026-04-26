import 'package:get/get.dart';

class ReciterDetailController extends GetxController {

  var playingIndex = RxnInt();

  final RxList<Map<String, String>> surahs = [
    {'number': '1', 'name': 'Al-Fatihah'},
    {'number': '2', 'name': 'Al-Baqarah'},
    {'number': '3', 'name': 'Al-Imran'},
    {'number': '4', 'name': 'An-Nisa'},
    {'number': '5', 'name': 'Al-Maidah'},
    {'number': '6', 'name': 'Al-Anam'},
    {'number': '7', 'name': 'Al-Araf'},
    {'number': '8', 'name': 'Al-Anfal'},
  ].obs;

  var searchQuery = ''.obs;

  // ✅ Search filter
  List<Map<String, String>> get filteredSurahs {
    if (searchQuery.value.isEmpty) return surahs;
    return surahs
        .where((s) =>
        s['name']!.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void togglePlay(int index) {
    if (playingIndex.value == index) {
      playingIndex.value = null;
    } else {
      playingIndex.value = index;
    }
  }

  bool isPlaying(int index) => playingIndex.value == index;
}