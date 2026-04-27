import '../../core/base_client.dart';
import '../../core/end_point.dart';
import 'reciter_model.dart';

class ReciterRepository {
  static Future<List<ReciterModel>> getReciters({
    String search = '',
    int page = 1,
    int limit = 12,
  }) async {
    try {
      print('🚀 fetchReciters called');
      print('➡️ Endpoint: ${EndPoint.reciters}');

      final response = await BaseClient.get(
        EndPoint.reciters,
        queryParams: {
          'search': search,
          'page': page,
          'limit': limit,
        },
      );

      print('✅ Response: ${response?.data}');

      if (response != null && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => ReciterModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Error: $e');
    }

    return [];
  }
}