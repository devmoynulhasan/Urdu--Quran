import 'package:get/get.dart';
import '../../home/reciterdata_screen.dart';

class AllRecitersController extends GetxController {

  var selectedIndex = RxnInt();
  var selectedNavIndex = 0.obs;

  void selectReciter(int index, String name) {
    selectedIndex.value = index;
    Get.to(() => ReciterDetailScreen(reciterName: name));
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }
}