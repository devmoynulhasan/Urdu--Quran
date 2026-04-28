class FavoriteModel {
  final String id;
  final String title;
  final int suraNumber;
  final String audioUrl;
  final String reciterName;

  FavoriteModel({
    required this.id,
    required this.title,
    required this.suraNumber,
    required this.audioUrl,
    required this.reciterName,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      suraNumber: json['suraNumber'] ?? 0,
      audioUrl: json['audioUrl'] ?? '',
      reciterName: json['reciter']?['name'] ?? '',
    );
  }
}