class SuraModel {
  final String id;
  final String title;
  final int suraNumber;
  final String audioUrl;

  SuraModel({
    required this.id,
    required this.title,
    required this.suraNumber,
    required this.audioUrl,
  });

  factory SuraModel.fromJson(Map<String, dynamic> json) {
    return SuraModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      suraNumber: json['suraNumber'] ?? 0,
      audioUrl: json['audioUrl'] ?? json['playbackUrl'] ?? '',
    );
  }
}