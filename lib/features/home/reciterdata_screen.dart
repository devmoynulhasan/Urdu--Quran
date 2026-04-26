import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontoller/reciterdatail_controller.dart';
import '../player/player_screen.dart';

class ReciterDetailScreen extends StatelessWidget {  // ✅ StatelessWidget
  final String reciterName;

  const ReciterDetailScreen({super.key, required this.reciterName});

  @override
  Widget build(BuildContext context) {
    final ReciterDetailController controller =
    Get.put(ReciterDetailController()); // ✅ Controller
    final TextEditingController searchController = TextEditingController();

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
                    onTap: () => Get.back(), // ✅ GetX back
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
                  style:
                  const TextStyle(fontSize: 18, color: Colors.white),
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: reciterName,
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
              child: controller.filteredSurahs.isEmpty
                  ? const Center(
                child: Text(
                  'No surah found',
                  style:
                  TextStyle(color: Colors.grey, fontSize: 18),
                ),
              )
                  : ListView.builder(
                padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: controller.filteredSurahs.length,
                itemBuilder: (context, index) {
                  final surah = controller.filteredSurahs[index];
                  final isPlaying = controller.isPlaying(index);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${surah['number']}. ${surah['name']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.download_outlined,
                            color: Colors.grey, size: 26),
                        const SizedBox(width: 14),

                        // ✅ Play Button
                        GestureDetector(
                          onTap: () {
                            controller.togglePlay(index);
                            Get.to(() => PlayerScreen(
                              surahName:
                              '${surah['number']}. ${surah['name']}',
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF007BFF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.graphic_eq
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
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