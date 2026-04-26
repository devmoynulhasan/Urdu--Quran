import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/favorites_controller/favorites_controller.dart';


class FavoritesScreen extends StatelessWidget {  // ✅ StatelessWidget
  final VoidCallback? onBackToHome;

  const FavoritesScreen({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController()); // ✅ Controller

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundPattern(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onBackToHome,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 24),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Favorites',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Obx — auto rebuild
                Expanded(
                  child: Obx(
                        () => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.favorites.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteItem(
                          controller.favorites[index],
                          index,
                          controller,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(
      String name, int index, FavoritesController controller) {

    bool isPlaying = controller.isPlaying(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: isPlaying
            ? Border.all(color: const Color(0xFF007BFF), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 19),
          ),
          const Spacer(),
          const Icon(Icons.download_outlined, color: Colors.grey, size: 24),
          const SizedBox(width: 15),

          // ✅ Play Button
          GestureDetector(
            onTap: () => controller.togglePlay(index),
            child: isPlaying
                ? _buildWaveform()
                : Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF007BFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow,
                  color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          width: 4,
          height: [20.0, 35.0, 25.0, 15.0][index],
          decoration: BoxDecoration(
            color: const Color(0xFF007BFF),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildBackgroundPattern() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: CustomPaint(painter: GeometricPainter()),
    );
  }
}

class GeometricPainter extends CustomPainter {
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