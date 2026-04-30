import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urdu_quran/features/home/reciterdata_screen.dart';
import '../../resource/app_images/app_imaeg.dart';
import '../controller/homecontoller/homescreen_controller.dart';
import '../favorites/favorites_screen.dart' hide AnimatedWaveform;
import 'allreciters_screen.dart';

class HomeScreen extends StatelessWidget {  // ✅ StatelessWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController()); // ✅ Controller
    final TextEditingController searchController = TextEditingController();

    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: controller.selectedNavIndex.value == 1
            ? FavoritesScreen(
          onBackToHome: () => controller.changeNavIndex(0),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Top Header
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007BFF),
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage(AssetPaths.quran_icon),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Urdu Quran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // ✅ Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(
                          fontSize: 20, color: Colors.white),
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search Reciter',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontSize: 20),
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey, size: 28),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.grey, size: 24),
                          onPressed: () {
                            searchController.clear();
                            controller.clearSearch();
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // ✅ Continue Listening
                  if (controller.searchQuery.value.isEmpty) ...[
                    const Text(
                      'Continue Listening',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ✅ Last played surah আছে কিনা check
                    Obx(() => controller.lastPlayedSurah.value.isEmpty

                    // ❌ কোনো surah play হয়নি
                        ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.music_off, color: Colors.grey, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'No surah played yet',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    )

                    // ✅ Last played surah দেখাবে
                        : GestureDetector(
                      onTap: controller.playLastPlayed,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.lastPlayedSurah.value,
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.lastPlayedReciter.value,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // ✅ Download button
                            GestureDetector(
                              onTap: controller.isDownloading.value
                                  ? null
                                  : () => controller.downloadLastPlayed(),
                              child: Obx(() => controller.isDownloading.value
                                  ? SizedBox(
                                width: 36,
                                height: 36,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: controller.downloadProgress.value,
                                      color: Colors.yellow,
                                      strokeWidth: 2,
                                    ),
                                    Text(
                                      '${(controller.downloadProgress.value * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const Icon(
                                Icons.download_outlined,
                                color: Colors.grey,
                                size: 28,
                              )),
                            ),

                            const SizedBox(width: 15),

                            // ✅ Play button
                            // ✅ Play / Waveform
                            GestureDetector(
                              onTap: () => controller.toggleLastPlayed(),
                              child: Obx(() => controller.isLastPlayedPlaying.value
                                  ? const AnimatedWaveform() // ✅ playing হলে waveform
                                  : Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007BFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(height: 35),
                  ],

                  // ✅ Pick a Reciter Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Pick a Reciters'
                            : '${controller.filteredReciters.length} Result(s) Found',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.searchQuery.value.isEmpty)
                        TextButton(
                          onPressed: () => Get.to(() => const AllRecitersScreen()),
                          child: const Text(
                            'See All',
                            style: TextStyle(color: Color(0xFF007BFF), fontSize: 20),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ Filtered Reciter List
            Expanded(
              child: controller.isLoading.value
                  ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF007BFF)),
              )
                  : controller.filteredReciters.isEmpty
                  ? const Center(
                child: Text('No reciter found',
                    style: TextStyle(color: Colors.grey, fontSize: 18)),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                itemCount: controller.filteredReciters.length,
                itemBuilder: (context, index) {
                  return _buildReciterCard(
                    controller,
                    controller.filteredReciters[index].name, // ✅
                    index,
                    context,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
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
                    onTap: () => controller.changeNavIndex(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: controller.selectedNavIndex.value == 0
                            ? const Color(0xFF007BFF)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.home_outlined,
                        color: controller.selectedNavIndex.value == 0
                            ? Colors.white
                            : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.changeNavIndex(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: controller.selectedNavIndex.value == 1
                            ? const Color(0xFF007BFF)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: controller.selectedNavIndex.value == 1
                            ? Colors.white
                            : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildReciterCard(
      HomeController controller,
      String name,
      int index,
      BuildContext context,
      ) {
    bool isSelected = controller.selectedReciterIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.selectReciter(index);
        Get.to(() => ReciterDetailScreen(
          reciterName: name,
          reciterId: controller.filteredReciters[index].id, // ✅
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}