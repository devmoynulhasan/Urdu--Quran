import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontoller/reciterdatail_controller.dart';
import '../player/player_screen.dart';

class ReciterDetailScreen extends StatefulWidget {
  final String reciterName;
  final String reciterId;

  const ReciterDetailScreen({
    super.key,
    required this.reciterName,
    required this.reciterId,
  });

  @override
  State<ReciterDetailScreen> createState() => _ReciterDetailScreenState();
}

class _ReciterDetailScreenState extends State<ReciterDetailScreen> {
  late ReciterDetailController controller;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ initState এ safe initialize
    controller = Get.put(
      ReciterDetailController(),
      tag: widget.reciterId,
    );
    controller.init(widget.reciterId);
  }

  @override
  void dispose() {
    searchController.dispose();
    Get.delete<ReciterDetailController>(tag: widget.reciterId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: const Color(0xFF007BFF), width: 1.5),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  onChanged: (value) =>
                      controller.onSearchChanged(value, widget.reciterId),
                  decoration: InputDecoration(
                    hintText: widget.reciterName,
                    hintStyle: const TextStyle(
                        color: Colors.white, fontSize: 18),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.grey, size: 24),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Surah List
            Expanded(
              child: controller.isLoading.value
                  ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF007BFF)),
              )
                  : controller.filteredSuras.isEmpty
                  ? const Center(
                child: Text(
                  'No surah found',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 18),
                ),
              )
                  : ListView.builder(
                padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: controller.filteredSuras.length,
                itemBuilder: (context, index) {
                  final sura = controller.filteredSuras[index];
                  final isPlaying = controller.isPlaying(index);

                  return GestureDetector(
                    // ✅ পুরো card — PlayerScreen এ যাবে
                    onTap: () {
                      Get.to(() => PlayerScreen(
                        surahName: '${sura.suraNumber}. ${sura.title}',
                        reciterName: widget.reciterName,
                        audioUrl: sura.audioUrl, // ✅
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(15),
                        border: isPlaying
                            ? Border.all(
                            color: const Color(0xFF007BFF),
                            width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          // ✅ Surah Name
                          Text(
                            '${sura.suraNumber}. ${sura.title}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const Spacer(),

                          // ✅ Download — শুধু download
                          GestureDetector(
                            onTap: () {
                              // TODO: download logic
                            },
                            child: const Icon(
                              Icons.download_outlined,
                              color: Colors.grey,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // ✅ Play — inline waveform toggle
                          GestureDetector(
                            onTap: () =>
                                controller.togglePlay(index),
                            child: isPlaying
                            // 🎵 Waveform
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(4, (i) {
                                return Container(
                                  margin: const EdgeInsets
                                      .symmetric(
                                      horizontal: 2),
                                  width: 4,
                                  height: [
                                    20.0,
                                    35.0,
                                    25.0,
                                    15.0
                                  ][i],
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xFF007BFF),
                                    borderRadius:
                                    BorderRadius.circular(
                                        10),
                                  ),
                                );
                              }),
                            )
                            // ▶ Play Button
                                : Container(
                              padding:
                              const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFF007BFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Nav
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.home_outlined,
                          color: Colors.grey, size: 28),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border,
                        color: Colors.grey, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}