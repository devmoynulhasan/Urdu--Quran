import 'package:get/get.dart';
import '../../../core/local_storage.dart';
import '../../favorite_model/favorite_repsitory.dart';
import '../../favorite_model/favoritemodel.dart';
import '../../player/player_screen.dart';

class FavoritesController extends GetxController {
  var playingIndex = RxnInt();
  var favorites = <FavoriteModel>[].obs;
  var isLoading = false.obs;

  final String guestId = 'guest-device-001';

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    final result = await FavoriteRepository.getFavorites(guestId: guestId);
    favorites.value = result;
    isLoading.value = false;
  }

  Future<void> toggleFavorite(String suraId) async {
    final isFav = isFavorite(suraId);

    if (isFav) {
      await FavoriteRepository.removeFavorite(
        guestId: guestId,
        suraId: suraId,
      );
    } else {
      await FavoriteRepository.addFavorite(
        guestId: guestId,
        suraId: suraId,
      );
    }

    await fetchFavorites();
  }

  bool isFavorite(String suraId) {
    return favorites.any((f) => f.id == suraId);
  }

  void togglePlay(int index) {
    playingIndex.value = playingIndex.value == index ? null : index;
  }

  bool isPlaying(int index) => playingIndex.value == index;

  // ✅ suraId এখন PlayerScreen এ pass হচ্ছে
  void playFavorite(FavoriteModel favorite) {
    Get.to(() => PlayerScreen(
      surahName: '${favorite.suraNumber}. ${favorite.title}',
      reciterName: favorite.reciterName,
      audioUrl: favorite.audioUrl,
      suraId: favorite.id, // ✅ pass করো
    ));
  }
}