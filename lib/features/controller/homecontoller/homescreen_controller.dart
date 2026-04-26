import 'package:get/get.dart';

class HomeController extends GetxController {

  var selectedReciterIndex = RxnInt();
  var selectedNavIndex = 0.obs;
  var searchQuery = ''.obs;

  final searchController = ''.obs; // search text track

  final RxList<String> reciters = [
    'Abdelaziz sheim',
    'Abdelbari Al- Toubayti',
    'Abdelaziz sheim',
    'Abdul Aziz Al-Ahmad',
    'Mishary Rashid Alafasy',
    'Saad El Ghamidi',
    'Abdul Rahman Al-Sudais',
    'Maher Al-Muaiqly',
  ].obs;

  // ✅ Filtered list — search query অনুযায়ী
  List<String> get filteredReciters {
    if (searchQuery.value.isEmpty) return reciters;
    return reciters
        .where((name) =>
        name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void selectReciter(int index) {
    selectedReciterIndex.value = index;
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }
}