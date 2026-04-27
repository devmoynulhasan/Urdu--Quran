class EndPoint {
  // ✅ Surah
  static const String allSurahs = '/surah';
  static String surahById(int id) => '/surah/$id';

  // ✅ Reciter
  static const String allReciters = '/edition/format/audio';
  static String reciterAudio(String reciter, int surahNumber) =>
      '/surah/$surahNumber/$reciter';

  // ✅ Auth (যদি পরে লাগে)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // ✅ Favorites (যদি server side লাগে)
  static const String favorites = '/favorites';
  static String deleteFavorite(int id) => '/favorites/$id';

  // ✅ Audio URL builder
  static String audioUrl(String reciter, int surahNumber) =>
      '${reciter}/$surahNumber.mp3';
}