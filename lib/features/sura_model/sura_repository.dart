import '../../core/base_client.dart';
import '../../core/end_point.dart';
import 'sura_model.dart';

class SuraRepository {
  static Future<List<SuraModel>> getSuras({
    required String reciterId,
    String search = '',
    int page = 1,
    int limit = 12,
  }) async {
    try {
      print('🚀 getSuras called for reciterId: $reciterId');

      final response = await BaseClient.get(
        EndPoint.suras,
        queryParams: {
          'search': search,
          'reciterId': reciterId,
          'page': page,
          'limit': limit,
        },
      );

      print('✅ Suras Response: ${response?.data}');

      if (response != null && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => SuraModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Suras Error: $e');
    }

    return [];
  }
}