import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urdu_quran/resource/app_images/app_imaeg.dart';
import '../controller/playercontroller/playerscreen_controller.dart';

class PlayerScreen extends StatefulWidget {
  final String surahName;
  final String reciterName;
  final String audioUrl;
  final String? suraId;
  final List<Map<String, String>> playlist;
  final int playlistIndex;

  const PlayerScreen({
    super.key,
    required this.surahName,
    required this.reciterName,
    required this.audioUrl,
    this.suraId,
    this.playlist = const [],
    this.playlistIndex = 0,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      PlayerController(),
      permanent: true,
    );
    controller.setPlaylist(widget.playlist, widget.playlistIndex);
    controller.initAudio(
      widget.audioUrl,
      widget.surahName,
      widget.reciterName,
      suraId: widget.suraId,
    );
  }

  @override
  void dispose() {
    // ✅ Get.delete() নেই — audio চলতে থাকবে
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(AssetPaths.mosque),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(40),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // ✅ Gradient Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 0.8, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(60),
                  Colors.black.withAlpha(200),
                  Colors.black,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ✅ Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(120),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // ✅ Surah + Reciter Name
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.surahName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    widget.reciterName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                // ✅ Actions Row
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      // Timer
                      GestureDetector(
                        onTap: () => _showTimerModal(),
                        child:
                        _buildPlayerAction(Icons.access_time),
                      ),

                      // Speed
                      GestureDetector(
                        onTap: () => _showSpeedModal(),
                        child: _buildPlayerActionText(
                            controller.currentSpeed.value),
                      ),

                      // ✅ Download
                      GestureDetector(
                        onTap: controller.isDownloading.value
                            ? null
                            : () => controller.downloadAudio(
                          widget.surahName,
                          widget.audioUrl,
                        ),
                        child: controller.isDownloading.value
                            ? SizedBox(
                          width: 48,
                          height: 48,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: controller
                                    .downloadProgress.value,
                                color:
                                const Color(0xFF007BFF),
                                strokeWidth: 2,
                              ),
                              Text(
                                '${(controller.downloadProgress.value * 100).toInt()}%',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        )
                            : _buildPlayerAction(
                            Icons.download_outlined),
                      ),

                      // ✅ Favorite
                      GestureDetector(
                        onTap: controller.isFavoriteLoading.value
                            ? null
                            : () => controller.toggleFavorite(),
                        child: controller.isFavoriteLoading.value
                            ? const SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                            : _buildPlayerAction(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isFavorite.value
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ✅ Loading / Slider
                if (controller.isLoading.value)
                  const CircularProgressIndicator(
                      color: Color(0xFF007BFF))
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape:
                            const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape:
                            const RoundSliderOverlayShape(
                                overlayRadius: 14),
                            activeTrackColor:
                            const Color(0xFF007BFF),
                            inactiveTrackColor:
                            Colors.grey.withAlpha(50),
                            thumbColor: const Color(0xFF007BFF),
                          ),
                          child: Slider(
                            value: controller
                                .position.value.inSeconds
                                .toDouble()
                                .clamp(
                              0,
                              controller
                                  .duration.value.inSeconds
                                  .toDouble(),
                            ),
                            max: controller.duration.value.inSeconds
                                .toDouble() >
                                0
                                ? controller
                                .duration.value.inSeconds
                                .toDouble()
                                : 1,
                            onChanged: controller.seekTo,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.formatDuration(
                                    controller.position.value),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              Text(
                                controller.formatDuration(
                                    controller.duration.value),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),

                // ✅ Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 40),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Repeat
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.repeat,
                            color: Colors.white, size: 28),
                      ),

                      // ✅ Previous
                      IconButton(
                        onPressed: () =>
                            controller.playPrevious(),
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: controller.playlist.isEmpty ||
                              controller.currentIndex <= 0
                              ? Colors.grey
                              : Colors.white,
                          size: 40,
                        ),
                      ),

                      // ✅ Play / Pause
                      GestureDetector(
                        onTap: controller.togglePlay,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF007BFF),
                                width: 2),
                          ),
                          child: Icon(
                            controller.isPlaying.value
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: const Color(0xFF007BFF),
                            size: 50,
                          ),
                        ),
                      ),

                      // ✅ Next
                      IconButton(
                        onPressed: () => controller.playNext(),
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: controller.playlist.isEmpty ||
                              controller.currentIndex >=
                                  controller.playlist.length - 1
                              ? Colors.grey
                              : Colors.white,
                          size: 40,
                        ),
                      ),

                      // ✅ Volume
                      GestureDetector(
                        onTap: () => _showVolumeModal(),
                        child: Icon(
                          controller.volume.value == 0
                              ? Icons.volume_off_rounded
                              : controller.volume.value < 0.5
                              ? Icons.volume_down_rounded
                              : Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // ✅ Volume Modal
  void _showVolumeModal() {
    Get.bottomSheet(
      Obx(() => Container(
        padding: const EdgeInsets.symmetric(
            vertical: 30, horizontal: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Volume',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                GestureDetector(
                  onTap: () => controller.decreaseVolume(),
                  child: const Icon(Icons.volume_down_rounded,
                      color: Colors.white, size: 28),
                ),
                Expanded(
                  child: Slider(
                    value: controller.volume.value,
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color(0xFF007BFF),
                    inactiveColor: Colors.grey.withAlpha(50),
                    onChanged: (val) {
                      controller.volume.value = val;
                      controller.player.setVolume(val);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.increaseVolume(),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Colors.white, size: 28),
                ),
              ],
            ),
            Text(
              '${(controller.volume.value * 100).toInt()}%',
              style: const TextStyle(
                  color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],
        ),
      )),
    );
  }

  // ✅ Timer Modal
  void _showTimerModal() {
    Get.bottomSheet(
      Obx(() => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 24, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Turn off Player After',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...controller.timerOptions.map((option) {
                bool isSelected =
                    controller.selectedTimer.value == option;
                return GestureDetector(
                  onTap: () {
                    controller.setTimer(option);
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF007BFF).withAlpha(40)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF007BFF)
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }

  // ✅ Speed Modal
  void _showSpeedModal() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(
            vertical: 24, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set Playback Speed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...controller.speeds.map((speed) {
              bool isSelected = (speed == 'Normal' &&
                  controller.currentSpeed.value == 'x1') ||
                  (speed == controller.currentSpeed.value);
              return GestureDetector(
                onTap: () {
                  controller.setSpeed(speed);
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8),
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha(20)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      speed,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF007BFF)
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        )),
      ),
    );
  }

  Widget _buildPlayerAction(IconData icon,
      {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildPlayerActionText(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}