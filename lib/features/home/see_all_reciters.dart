import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urdu_quran/features/home/reciterdata_screen.dart';
import '../controller/homecontoller/homescreen_controller.dart';

class AllRecitersScreen extends StatelessWidget {
  const AllRecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ Background pattern
          CustomPaint(
            painter: _GeometricPainter(),
            size: Size.infinite,
          ),

          SafeArea(
            child: Column(
              children: [
                // ✅ Header
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
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Pick a Reciters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // ✅ List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF007BFF)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: controller.filteredReciters.length,
                      itemBuilder: (context, index) {
                        final reciter = controller.filteredReciters[index];
                        return GestureDetector(
                          onTap: () {
                            controller.selectReciter(index);
                            Get.to(() => ReciterDetailScreen(
                              reciterName: reciter.name,
                              reciterId: reciter.id,
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 22, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              reciter.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Background geometric pattern
class _GeometricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withAlpha(20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double spacing = 40;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        Path path = Path();
        path.moveTo(x + spacing / 2, y);
        path.lineTo(x + spacing, y + spacing / 2);
        path.lineTo(x + spacing / 2, y + spacing);
        path.lineTo(x, y + spacing / 2);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}