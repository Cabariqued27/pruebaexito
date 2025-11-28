import 'dart:convert';

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final String categoryName;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.categoryName,
    required this.images,
  });

  ProductModel copyWith({
    int? id,
    String? title,
    String? slug,
    double? price,
    String? description,
    String? categoryName,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'categoryName': categoryName,
      'images': images,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      slug: map['slug'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      categoryName: map['category']?['name'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, slug: $slug, price: $price, description: $description, categoryName: $categoryName, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.title == title &&
        other.slug == slug &&
        other.price == price &&
        other.description == description &&
        other.categoryName == categoryName &&
        other.images == images;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      slug.hashCode ^
      price.hashCode ^
      description.hashCode ^
      categoryName.hashCode ^
      images.hashCode;
}
