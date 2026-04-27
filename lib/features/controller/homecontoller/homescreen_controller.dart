import 'package:get/get.dart';
import '../../../core/local_storage.dart';
import '../../player/player_screen.dart';

class HomeController extends GetxController {

  var selectedReciterIndex = RxnInt();
  var selectedNavIndex = 0.obs;
  var searchQuery = ''.obs;

  // ✅ Last played surah
  var lastPlayedSurah = ''.obs;
  var lastPlayedReciter = ''.obs;

  final RxList<String> reciters = [
    'Abdelaziz sheim',
    'Abdelbari Al- Toubayti',
    'Abdul Aziz Al-Ahmad',
    'Mishary Rashid Alafasy',
    'Saad El Ghamidi',
    'Abdul Rahman Al-Sudais',
    'Maher Al-Muaiqly',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLastPlayed(); // ✅ App open হলে last played load করবে
  }

  // ✅ LocalStorage থেকে load
  void _loadLastPlayed() {
    lastPlayedSurah.value = LocalStorage.getLastPlayed() ?? '';
    lastPlayedReciter.value = LocalStorage.getLastPlayedReciter() ?? '';
  }

  List<String> get filteredReciters {
    if (searchQuery.value.isEmpty) return reciters;
    return reciters
        .where((name) =>
        name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;
  void clearSearch() => searchQuery.value = '';
  void selectReciter(int index) => selectedReciterIndex.value = index;
  void changeNavIndex(int index) => selectedNavIndex.value = index;

  // ✅ Continue Listening play button
  void playLastPlayed() {
    if (lastPlayedSurah.value.isNotEmpty) {
      Get.to(() => PlayerScreen(
        surahName: lastPlayedSurah.value,
        reciterName: lastPlayedReciter.value, // ✅ add করো
      ));
    }
  }
}