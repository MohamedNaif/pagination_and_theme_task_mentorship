class ProductModel {
  final int id;
  final String title;
  final String description;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String? ?? '',
    thumbnail: json['thumbnail'] as String? ?? '',
  );
}
