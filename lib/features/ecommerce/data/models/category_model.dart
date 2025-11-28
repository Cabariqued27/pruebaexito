import 'dart:convert';

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  CategoryModel({required this.id, required this.name, required this.slug, required this.image});

  CategoryModel copyWith({int? id, String? name, String? slug, String? image}) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'slug': slug, 'image': image};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(id: $id, name: $name, slug: $slug, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ slug.hashCode ^ image.hashCode;
}
