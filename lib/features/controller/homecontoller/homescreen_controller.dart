import 'package:get/get.dart';
import '../../../core/local_storage.dart';
import '../../player/player_screen.dart';
import '../../reciter_model/reciter_model.dart';
import '../../reciter_model/reciter_respository.dart';

class HomeController extends GetxController {

  var selectedReciterIndex = RxnInt();
  var selectedNavIndex = 0.obs;
  var searchQuery = ''.obs;

  // ✅ Last played
  var lastPlayedSurah = ''.obs;
  var lastPlayedReciter = ''.obs;

  // ✅ API reciters
  var reciters = <ReciterModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLastPlayed();
    fetchReciters(); // ✅ API থেকে load
  }

  // ✅ API call
  Future<void> fetchReciters({String search = ''}) async {
    isLoading.value = true;
    final result = await ReciterRepository.getReciters(search: search);
    reciters.value = result;
    isLoading.value = false;
  }

  // ✅ LocalStorage থেকে load
  void _loadLastPlayed() {
    lastPlayedSurah.value = LocalStorage.getLastPlayed() ?? '';
    lastPlayedReciter.value = LocalStorage.getLastPlayedReciter() ?? '';
  }

  void reloadLastPlayed() {
    lastPlayedSurah.value = LocalStorage.getLastPlayed() ?? '';
    lastPlayedReciter.value = LocalStorage.getLastPlayedReciter() ?? '';
  }

  // ✅ Search — API call with query
  void onSearchChanged(String value) {
    searchQuery.value = value;
    fetchReciters(search: value); // ✅ API এ search পাঠাও
  }

  void clearSearch() {
    searchQuery.value = '';
    fetchReciters(); // ✅ সব reciters আবার load
  }

  // ✅ Filtered list — এখন API থেকে আসছে তাই শুধু reciters return
  List<ReciterModel> get filteredReciters => reciters;

  void selectReciter(int index) => selectedReciterIndex.value = index;
  void changeNavIndex(int index) => selectedNavIndex.value = index;

  // ✅ Continue Listening play
  void playLastPlayed() async {
    if (lastPlayedSurah.value.isNotEmpty) {
      await Get.to(() => PlayerScreen(
        surahName: lastPlayedSurah.value,
        reciterName: lastPlayedReciter.value,
      ));
      reloadLastPlayed(); // ✅ ফিরে আসলে reload
    }
  }
}