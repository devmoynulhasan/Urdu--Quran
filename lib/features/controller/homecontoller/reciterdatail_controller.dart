import 'package:get/get.dart';
import '../../sura_model/sura_model.dart';
import '../../sura_model/sura_repository.dart';

class ReciterDetailController extends GetxController {

  var playingIndex = RxnInt();
  var suras = <SuraModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  // ✅ API থেকে suras load
  Future<void> fetchSuras({required String reciterId, String search = ''}) async {
    isLoading.value = true;
    final result = await SuraRepository.getSuras(
      reciterId: reciterId,
      search: search,
    );
    suras.value = result;
    isLoading.value = false;
  }

  // ✅ Search filter
  List<SuraModel> get filteredSuras {
    if (searchQuery.value.isEmpty) return suras;
    return suras
        .where((s) =>
        s.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value, String reciterId) {
    searchQuery.value = value;
    fetchSuras(reciterId: reciterId, search: value);
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