import 'package:get/get.dart';
import '../../home/reciterdata_screen.dart';

class AllRecitersController extends GetxController {

  var selectedIndex = RxnInt();
  var selectedNavIndex = 0.obs;

// ✅ AllRecitersController
  void selectReciter(int index, String name, String reciterId) {
    selectedIndex.value = index;
    Get.to(() => ReciterDetailScreen(
      reciterName: name,
      reciterId: reciterId, // ✅ actual id pass করো
    ));
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }
}