import 'package:get/get.dart';
import '../../sura_model/sura_model.dart';
import '../../sura_model/sura_repository.dart';

class ReciterDetailController extends GetxController {

  var playingIndex = RxnInt();
  var suras = <SuraModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  String reciterId = '';

  void init(String id) {
    reciterId = id;
    fetchSuras(reciterId: id);
  }

  Future<void> fetchSuras({required String reciterId, String search = ''}) async {
    isLoading.value = true;
    final result = await SuraRepository.getSuras(
      reciterId: reciterId,
      search: search,
    );
    suras.value = result;
    isLoading.value = false;
  }

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
    playingIndex.value = playingIndex.value == index ? null : index;
  }

  bool isPlaying(int index) => playingIndex.value == index;
}