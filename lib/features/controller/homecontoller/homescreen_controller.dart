import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urdu_quran/features/player/global_audio_manager.dart';
import '../../../core/local_storage.dart';
import '../../player/player_screen.dart';
import '../../reciter_model/reciter_model.dart';
import '../../reciter_model/reciter_respository.dart';

class HomeController extends GetxController {

  var selectedReciterIndex = RxnInt();
  var selectedNavIndex = 0.obs;
  var searchQuery = ''.obs;
  var showAllReciters = false.obs;

  var lastPlayedSurah = ''.obs;
  var lastPlayedReciter = ''.obs;
  var lastPlayedAudioUrl = ''.obs;

  var reciters = <ReciterModel>[].obs;
  var isLoading = false.obs;

  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  // ✅ Inline play/pause
  var isLastPlayedPlaying = false.obs;
  AudioPlayer? _audioPlayer;

  @override
  void onInit() {
    super.onInit();
    _loadLastPlayed();
    fetchReciters();
  }

  Future<void> fetchReciters({String search = ''}) async {
    isLoading.value = true;
    final result = await ReciterRepository.getReciters(search: search);
    reciters.value = result;
    isLoading.value = false;
  }

  void _loadLastPlayed() {
    lastPlayedSurah.value = LocalStorage.getLastPlayed() ?? '';
    lastPlayedReciter.value = LocalStorage.getLastPlayedReciter() ?? '';
    lastPlayedAudioUrl.value = LocalStorage.getLastPlayedAudioUrl() ?? '';
  }

  void reloadLastPlayed() {
    lastPlayedSurah.value = LocalStorage.getLastPlayed() ?? '';
    lastPlayedReciter.value = LocalStorage.getLastPlayedReciter() ?? '';
    lastPlayedAudioUrl.value = LocalStorage.getLastPlayedAudioUrl() ?? '';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    fetchReciters(search: value);
  }

  void clearSearch() {
    searchQuery.value = '';
    fetchReciters();
  }

  void toggleSeeAll() {
    showAllReciters.value = !showAllReciters.value;
  }

  List<ReciterModel> get filteredReciters => reciters;

  void selectReciter(int index) => selectedReciterIndex.value = index;
  void changeNavIndex(int index) => selectedNavIndex.value = index;

  // ✅ Inline play/pause
  Future<void> toggleLastPlayed() async {
    if (lastPlayedAudioUrl.value.isEmpty) return;

    // ✅ GlobalAudioManager থেকে shared player নাও
    final audioPlayer = GlobalAudioManager.to.player;

    if (isLastPlayedPlaying.value &&
        GlobalAudioManager.to.activeControllerId == 'home') {
      await audioPlayer.pause();
      isLastPlayedPlaying.value = false;
      GlobalAudioManager.to.unregister('home');
      return;
    }

    // ✅ register করলে আগের যেকোনো controller বন্ধ হবে
    GlobalAudioManager.to.register('home', () {
      isLastPlayedPlaying.value = false;
    });

    try {
      await audioPlayer.setUrl(lastPlayedAudioUrl.value);
      await audioPlayer.play();
      isLastPlayedPlaying.value = true;

      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (GlobalAudioManager.to.activeControllerId == 'home') {
            isLastPlayedPlaying.value = false;
            GlobalAudioManager.to.unregister('home');
          }
        }
      });
    } catch (e) {
      print('❌ Audio Error: $e');
      isLastPlayedPlaying.value = false;
      GlobalAudioManager.to.unregister('home');
    }
  }

  void playLastPlayed() async {
    if (lastPlayedSurah.value.isNotEmpty) {

      // ✅ home audio চলছে কিনা — position নাও
      final pos = (isLastPlayedPlaying.value &&
          GlobalAudioManager.to.activeControllerId == 'home')
          ? GlobalAudioManager.to.player.position
          : Duration.zero;

      // ✅ home audio আগে বন্ধ করো, তারপর PlayerScreen এ যাও
      if (isLastPlayedPlaying.value) {
        GlobalAudioManager.to.player.pause();
        GlobalAudioManager.to.unregister('home');
        isLastPlayedPlaying.value = false;
      }

      await Get.to(() => PlayerScreen(
        surahName: lastPlayedSurah.value,
        reciterName: lastPlayedReciter.value,
        audioUrl: lastPlayedAudioUrl.value,
        initialPosition: pos, // ✅ যেখানে ছিল সেখান থেকে শুরু হবে
      ));
      reloadLastPlayed();
    }
  }

  // ✅ Download last played
  Future<void> downloadLastPlayed() async {
    if (lastPlayedAudioUrl.value.isEmpty) return;

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

      final filePath =
          '/storage/emulated/0/Download/${lastPlayedSurah.value}.mp3';

      await dio.download(
        lastPlayedAudioUrl.value,
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
        '${lastPlayedSurah.value} saved to Downloads',
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
    GlobalAudioManager.to.unregister('home');
    _audioPlayer?.dispose();
    super.onClose();
  }
}