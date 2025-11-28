import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pruebaexito/features/ecommerce/data/models/category_model.dart';

class CategoryDatasource {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1/categories';

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);

    return data.map((item) => CategoryModel.fromMap(item)).toList();
  }
}
