import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urdu_quran/features/player/global_audio_manager.dart';
import 'package:urdu_quran/features/player/shared_audio_satatus.dart';
import '../../sura_model/sura_model.dart';
import '../../sura_model/sura_repository.dart';

class ReciterDetailController extends GetxController {
  // ✅ GlobalAudioManager থেকে shared player নাও
  AudioPlayer get _audioPlayer => GlobalAudioManager.to.player;

  var playingIndex = RxnInt();
  var suras = <SuraModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  var downloadingName = ''.obs;

  String reciterId = '';
  String reciterName = '';

  // controllerId unique রাখার জন্য reciterId ব্যবহার করবো
  String get _controllerId => 'reciter_$reciterId';

  @override
  void onInit() {
    super.onInit();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // শুধু তখনই null করো যখন এই controller active
        if (GlobalAudioManager.to.activeControllerId == _controllerId) {
          playingIndex.value = null;
        }
      }
    });
  }

  void init(String id, String name) {
    reciterId = id;
    reciterName = name;
    fetchSuras(reciterId: id);
  }

  Future<void> fetchSuras({
    required String reciterId,
    String search = '',
  }) async {
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

  Future<void> togglePlay(int index, String audioUrl) async {
    if (playingIndex.value == index &&
        GlobalAudioManager.to.activeControllerId == _controllerId) {
      await _audioPlayer.pause();
      playingIndex.value = null;
      GlobalAudioManager.to.unregister(_controllerId);
    } else {
      // ✅ register করলে আগের যেকোনো controller (Favorites বা Player) বন্ধ হবে
      GlobalAudioManager.to.register(_controllerId, () {
        playingIndex.value = null;
      });

      playingIndex.value = index;
      try {
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();

        // ✅ SharedAudioState update
        final sura = filteredSuras[index];
        SharedAudioState.to.updateLastPlayed(
          surahName: '${sura.suraNumber}. ${sura.title}',
          reciterName: reciterName,
          audioUrl: audioUrl,
        );
      } catch (e) {
        playingIndex.value = null;
      }
    }
  }

  bool isPlaying(int index) =>
      playingIndex.value == index &&
          GlobalAudioManager.to.activeControllerId == _controllerId;

  /// PlayerScreen-এ যাওয়ার আগে position নাও এবং pause করো
  Duration stopAndGetPosition(int index) {
    final isThisControllerActive =
        GlobalAudioManager.to.activeControllerId == _controllerId;
    final pos = (isThisControllerActive && isPlaying(index))
        ? _audioPlayer.position
        : Duration.zero;

    _audioPlayer.pause();
    GlobalAudioManager.to.unregister(_controllerId);
    playingIndex.value = null;

    return pos;
  }

  void stopAndClear() {
    _audioPlayer.pause();
    GlobalAudioManager.to.unregister(_controllerId);
    playingIndex.value = null;
  }

  // ✅ Download
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
    // ✅ dispose করবে না — GlobalAudioManager dispose করবে
    GlobalAudioManager.to.unregister(_controllerId);
    super.onClose();
  }
}