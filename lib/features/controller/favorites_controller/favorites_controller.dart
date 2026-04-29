import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../favorite_model/favorite_repsitory.dart';
import '../../favorite_model/favoritemodel.dart';
import '../../player/player_screen.dart';

class FavoritesController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  var playingIndex = RxnInt();
  var favorites = <FavoriteModel>[].obs;
  var isLoading = false.obs;

  // ✅ Download progress
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  var downloadingName = ''.obs;

  final String guestId = 'guest-device-001';

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playingIndex.value = null;
      }
    });
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    final result = await FavoriteRepository.getFavorites(guestId: guestId);
    favorites.value = result;
    isLoading.value = false;
  }

  Future<void> toggleFavorite(String suraId) async {
    try {
      if (isFavorite(suraId)) {
        favorites.removeWhere((f) => f.id == suraId);
        await FavoriteRepository.removeFavorite(
          guestId: guestId,
          suraId: suraId,
        );
        Get.snackbar('Removed', 'Removed from favorites',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await FavoriteRepository.addFavorite(
          guestId: guestId,
          suraId: suraId,
        );
        await fetchFavorites();
        Get.snackbar('Added', 'Added to favorites',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('❌ Toggle Error: $e');
      await fetchFavorites();
    }
  }

  bool isFavorite(String suraId) => favorites.any((f) => f.id == suraId);

  Future<void> togglePlay(int index, String audioUrl) async {
    if (playingIndex.value == index) {
      await _audioPlayer.pause();
      playingIndex.value = null;
    } else {
      playingIndex.value = index;
      try {
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
      } catch (e) {
        print('❌ Audio Error: $e');
        playingIndex.value = null;
      }
    }
  }

  bool isPlaying(int index) => playingIndex.value == index;

  void playFavorite(FavoriteModel favorite) {
    _audioPlayer.pause();
    playingIndex.value = null;

    Get.to(() => PlayerScreen(
      surahName: '${favorite.suraNumber}. ${favorite.title}',
      reciterName: favorite.reciterName,
      audioUrl: favorite.audioUrl,
      suraId: favorite.id,
    ))?.then((_) {
      fetchFavorites();
    });
  }

  // ✅ Download with progress
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
      downloadingName.value = surahName;

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
      Get.snackbar(
        'Downloaded',
        '$surahName saved to Downloads',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
    } catch (e) {
      isDownloading.value = false;
      print('❌ Download Error: $e');
      Get.snackbar('Error', 'Download failed',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}