import 'package:dio/dio.dart';
import 'package:urdu_quran/features/favorite_model/favoritemodel.dart';
import '../../core/base_client.dart';
import '../../core/end_point.dart';

class FavoriteRepository {

  // ✅ Favorite যোগ করো — POST /quran/favorites
  static Future<bool> addFavorite({
    required String guestId,
    required String suraId,
  }) async {
    try {
      final response = await BaseClient.post(
        EndPoint.favorites,
        queryParams: {
          'guestId': guestId,
          'suraId': suraId,
        },
      );
      print('✅ Add Favorite: ${response?.data}');
      return response?.data['success'] == true;
    } catch (e) {
      print('❌ Add Favorite Error: $e');
      return false;
    }
  }

  // ✅ Favorites list আনো — GET /quran/favorites
  static Future<List<FavoriteModel>> getFavorites({
    required String guestId,
  }) async {
    try {
      final response = await BaseClient.get(
        EndPoint.favorites,
        queryParams: {'guestId': guestId},
      );
      print('✅ Get Favorites: ${response?.data}');
      if (response != null && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => FavoriteModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Get Favorites Error: $e');
    }
    return [];
  }

  // ✅ Favorite remove করো — DELETE /quran/favorites/{suraId}
  static Future<bool> removeFavorite({
    required String guestId,
    required String suraId,
  }) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = BaseClient.dio.options.baseUrl; // ✅ BaseClient এর baseUrl নাও

      final response = await dio.delete(
        '${EndPoint.favorites}/$suraId', // ✅ /quran/favorites/{suraId}
        options: Options(
          headers: {
            'x-guest-id': guestId,
          },
        ),
      );
      print('✅ Remove Favorite: ${response.data}');
      return response.data['success'] == true;
    } catch (e) {
      print('❌ Remove Favorite Error: $e');
      return false;
    }
  }
}