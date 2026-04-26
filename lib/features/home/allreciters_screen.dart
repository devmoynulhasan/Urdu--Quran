import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontoller/allreciters_controller.dart';

class AllRecitersScreen extends StatelessWidget {  // ✅ StatelessWidget
  final List<String> reciters;

  const AllRecitersScreen({super.key, required this.reciters});

  @override
  Widget build(BuildContext context) {
    final AllRecitersController controller =
    Get.put(AllRecitersController()); // ✅ Controller

    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
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
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Pick a Reciters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Reciter List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 120),
                itemCount: reciters.length,
                itemBuilder: (context, index) {
                  return _buildReciterCard(
                    controller,
                    reciters[index],
                    index,
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
                  // ✅ Home Button
                  GestureDetector(
                    onTap: () {
                      controller.changeNavIndex(0);
                      Get.back();
                    },
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

                  // ✅ Favourite Button
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
      AllRecitersController controller,
      String name,
      int index,
      ) {
    bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.selectReciter(index, name), // ✅ GetX navigate
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF007BFF)
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}