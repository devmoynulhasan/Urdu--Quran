import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/local_storage.dart';
import '../../favorite_model/favorite_repsitory.dart';
import '../favorites_controller/favorites_controller.dart'; // ✅ import

class PlayerController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var currentSpeed = 'x1'.obs;
  var selectedTimer = 'Never'.obs;
  var isLoading = false.obs;

  var isFavorite = false.obs;
  var isFavoriteLoading = false.obs;

  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  String? currentSuraId;
  final String guestId = 'guest-device-001';

  final List<String> speeds = ['x 0.7', 'Normal', 'x 1.5', 'x 2'];
  final List<String> timerOptions = [
    'Never',
    '5 Minutes',
    '10 Minutes',
    '15 Minutes',
    '30 Minutes',
    '45 Minutes',
    '60 Minutes',
  ];

  Future<void> initAudio(
      String audioUrl,
      String surahName,
      String reciterName, {
        String? suraId,
      }) async {
    try {
      isLoading.value = true;
      currentSuraId = suraId;

      await player.setUrl(audioUrl);
      await LocalStorage.saveLastPlayed(surahName, reciterName, audioUrl);

      player.positionStream.listen((pos) => position.value = pos);
      player.durationStream
          .listen((dur) => duration.value = dur ?? Duration.zero);
      player.playingStream.listen((playing) => isPlaying.value = playing);

      isLoading.value = false;
      player.play();

      if (suraId != null) {
        await checkFavoriteStatus(suraId);
      }
    } catch (e) {
      isLoading.value = false;
      print('❌ Audio Error: $e');
    }
  }

  // ✅ Favorite status check
  Future<void> checkFavoriteStatus(String suraId) async {
    isFavoriteLoading.value = true;
    final favorites =
    await FavoriteRepository.getFavorites(guestId: guestId);
    isFavorite.value = favorites.any((f) => f.id == suraId);
    isFavoriteLoading.value = false;
  }

  // ✅ Favorite toggle — UI সাথে সাথে update + FavoritesController sync
  Future<void> toggleFavorite() async {
    if (currentSuraId == null) return;
    isFavoriteLoading.value = true;

    try {
      if (isFavorite.value) {
        // ✅ আগে UI update
        isFavorite.value = false;

        await FavoriteRepository.removeFavorite(
          guestId: guestId,
          suraId: currentSuraId!,
        );
        Get.snackbar('Removed', 'Removed from favorites',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        // ✅ আগে UI update
        isFavorite.value = true;

        await FavoriteRepository.addFavorite(
          guestId: guestId,
          suraId: currentSuraId!,
        );
        Get.snackbar('Added', 'Added to favorites',
            snackPosition: SnackPosition.BOTTOM);
      }

      // ✅ FavoritesController active থাকলে sync করো
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().fetchFavorites();
      }
    } catch (e) {
      // ✅ Error হলে আগের state ফিরিয়ে দাও
      isFavorite.value = !isFavorite.value;
      print('❌ Favorite Error: $e');
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM);
    }

    isFavoriteLoading.value = false;
  }

  Future<void> downloadAudio(String surahName, String audioUrl) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt < 30) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied', 'Storage permission required',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
      } else if (sdkInt < 33) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied', 'Please allow storage access',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
      }
    }

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      final httpClient = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      final adapter = IOHttpClientAdapter();
      adapter.createHttpClient = () => httpClient;

      final dio = Dio();
      dio.httpClientAdapter = adapter;

      final filePath = '/storage/emulated/0/Download/$surahName.mp3';

      await dio.download(
        audioUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      isDownloading.value = false;
      Get.snackbar('Downloaded', '$surahName saved to Downloads',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isDownloading.value = false;
      print('❌ Download Error: $e');
      Get.snackbar('Error', 'Download failed',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void togglePlay() {
    if (isPlaying.value) {
      player.pause();
    } else {
      player.play();
    }
  }

  void seekTo(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  void setSpeed(String speed) {
    double speedValue = speed == 'Normal'
        ? 1.0
        : speed == 'x 0.7'
        ? 0.7
        : speed == 'x 1.5'
        ? 1.5
        : 2.0;
    player.setSpeed(speedValue);
    currentSpeed.value = speed == 'Normal' ? 'x1' : speed;
  }

  void setTimer(String timer) {
    selectedTimer.value = timer;
  }

  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}