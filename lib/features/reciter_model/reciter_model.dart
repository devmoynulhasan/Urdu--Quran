class ReciterModel {
  final String id;
  final String name;
  final String image;

  ReciterModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}