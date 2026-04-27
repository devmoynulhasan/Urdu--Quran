import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _box = GetStorage();

  // ✅ Token
  static Future<void> saveToken(String token) async =>
      await _box.write('token', token);

  static String? getToken() => _box.read('token');

  static Future<void> removeToken() async => await _box.remove('token');

  // ✅ Favorites
  static Future<void> saveFavorites(List<String> favorites) async =>
      await _box.write('favorites', favorites);

  static List<String> getFavorites() {
    final data = _box.read<List>('favorites');
    return data?.map((e) => e.toString()).toList() ?? [];
  }

  static Future<void> addFavorite(String surahName) async {
    final list = getFavorites();
    if (!list.contains(surahName)) {
      list.add(surahName);
      await saveFavorites(list);
    }
  }

  static Future<void> removeFavorite(String surahName) async {
    final list = getFavorites();
    list.remove(surahName);
    await saveFavorites(list);
  }

  static bool isFavorite(String surahName) =>
      getFavorites().contains(surahName);

  // ✅ Last Played — surahName + reciterName একসাথে save
  static Future<void> saveLastPlayed(
      String surahName, String reciterName) async {
    await _box.write('last_played', surahName);
    await _box.write('last_played_reciter', reciterName); // ✅ নতুন
  }

  static String? getLastPlayed() => _box.read('last_played');
  static String? getLastPlayedReciter() => _box.read('last_played_reciter'); // ✅ নতুন

  // ✅ Selected Reciter
  static Future<void> saveSelectedReciter(String reciter) async =>
      await _box.write('selected_reciter', reciter);

  static String getSelectedReciter() =>
      _box.read('selected_reciter') ?? 'ar.alafasy';

  // ✅ Clear All
  static Future<void> clearAll() async => await _box.erase();
}