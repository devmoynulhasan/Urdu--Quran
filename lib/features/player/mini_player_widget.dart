import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:urdu_quran/features/player/global_audio_manager.dart';
import 'package:urdu_quran/features/player/shared_audio_satatus.dart';
import 'package:urdu_quran/features/player/player_screen.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = SharedAudioState.to;

      if (state.isPlayerScreenOpen.value) return const SizedBox.shrink();

      if (state.lastPlayedSurah.value.isEmpty) return const SizedBox.shrink();

      final player = GlobalAudioManager.to.player;

      return StreamBuilder<PlayerState>(
        stream: player.playerStateStream,
        builder: (context, snapshot) {
          final isPlaying = snapshot.data?.playing ?? false;
          final processingState = snapshot.data?.processingState;

          return GestureDetector(
            onTap: () {
              Get.to(() => PlayerScreen(
                surahName: state.lastPlayedSurah.value,
                reciterName: state.lastPlayedReciter.value,
                audioUrl: state.lastPlayedAudioUrl.value,
              ));
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).padding.bottom + 8,
                top: 8,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1C1C2E), Color(0xFF16213E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF007BFF).withAlpha(60),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007BFF).withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    // ✅ Left icon box
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF007BFF).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF007BFF).withAlpha(80),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: isPlaying
                            ? const _MiniWaveform()
                            : const Icon(
                          Icons.music_note,
                          color: Color(0xFF007BFF),
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ✅ Surah + Reciter name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.lastPlayedSurah.value,
                            style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            state.lastPlayedReciter.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ✅ Play / Pause button
                    GestureDetector(
                      onTap: () {
                        if (isPlaying) {
                          player.pause();
                        } else {
                          player.play();
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF007BFF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ✅ Close button
                    GestureDetector(
                      onTap: () {
                        player.pause();
                        SharedAudioState.to.clear();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ✅ Mini waveform animation
class _MiniWaveform extends StatefulWidget {
  const _MiniWaveform();

  @override
  State<_MiniWaveform> createState() => _MiniWaveformState();
}

class _MiniWaveformState extends State<_MiniWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final heights = [
          5.0 + (_controller.value * 12),
          16.0 - (_controller.value * 7),
          7.0 + (_controller.value * 9),
          12.0 - (_controller.value * 6),
        ];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: heights[i],
              decoration: BoxDecoration(
                color: const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        );
      },
    );
  }
}