import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urdu_quran/resource/app_images/app_imaeg.dart';
import '../controller/playercontroller/playerscreen_controller.dart';

class PlayerScreen extends StatelessWidget {  // ✅ StatelessWidget
  final String surahName;

  const PlayerScreen({super.key, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.put(PlayerController());

    // ✅ Audio init
    controller.initAudio(surahName);

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
                fit: BoxFit.cover,
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
                      horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(), // ✅ GetX back
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

                // ✅ Surah Name
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    surahName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ✅ Actions Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _showTimerModal(controller),
                        child: _buildPlayerAction(Icons.access_time),
                      ),
                      GestureDetector(
                        onTap: () => _showSpeedModal(controller),
                        child: _buildPlayerActionText(
                            controller.currentSpeed.value),
                      ),
                      _buildPlayerAction(Icons.download_outlined),
                      _buildPlayerAction(Icons.favorite_border),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ✅ Progress Slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14),
                          activeTrackColor: const Color(0xFF007BFF),
                          inactiveTrackColor: Colors.grey.withAlpha(50),
                          thumbColor: const Color(0xFF007BFF),
                        ),
                        child: Slider(
                          value: controller.position.value.inSeconds
                              .toDouble()
                              .clamp(
                            0,
                            controller.duration.value.inSeconds.toDouble(),
                          ),
                          max: controller.duration.value.inSeconds
                              .toDouble() >
                              0
                              ? controller.duration.value.inSeconds.toDouble()
                              : 1,
                          onChanged: controller.seekTo,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formatDuration(
                                  controller.position.value),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              controller.formatDuration(
                                  controller.duration.value),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.repeat,
                            color: Colors.white, size: 28),
                      ),
                      IconButton(
                        onPressed: () => controller.player.seekToPrevious(),
                        icon: const Icon(Icons.skip_previous_rounded,
                            color: Colors.white, size: 40),
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
                                color: const Color(0xFF007BFF), width: 2),
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

                      IconButton(
                        onPressed: () => controller.player.seekToNext(),
                        icon: const Icon(Icons.skip_next_rounded,
                            color: Colors.white, size: 40),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up_rounded,
                            color: Colors.white, size: 28),
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

  // ✅ Timer Modal
  void _showTimerModal(PlayerController controller) {
    Get.bottomSheet(
      Obx(() => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
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
                bool isSelected = controller.selectedTimer.value == option;
                return GestureDetector(
                  onTap: () {
                    controller.setTimer(option);
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
  void _showSpeedModal(PlayerController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
              bool isSelected =
                  (speed == 'Normal' && controller.currentSpeed.value == 'x1') ||
                      (speed == controller.currentSpeed.value);
              return GestureDetector(
                onTap: () {
                  controller.setSpeed(speed);
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildPlayerAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
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