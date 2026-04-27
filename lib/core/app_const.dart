class AppConst {
  // ✅ App Info
  static const String appName = 'Urdu Quran';
  static const String appVersion = '1.0.0';

  // ✅ API Base
  static const String baseUrl = 'http://13.233.165.158:5000/api/v1';
  static const String audioBaseUrl = 'https://cdn.islamic.network/quran/audio/128';

  // ✅ Default Reciter
  static const String defaultReciter = 'ar.alafasy';

  // ✅ Local Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user_data';
  static const String favoritesKey = 'favorites';
  static const String lastPlayedKey = 'last_played';
  static const String selectedReciterKey = 'selected_reciter';

  // ✅ Timeouts
  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;
}