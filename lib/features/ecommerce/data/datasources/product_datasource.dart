import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';

class ProductDatasource {
  final String _baseUrl = "https://api.escuelajs.co/api/v1/products";

  Future<List<ProductModel>> getProductsByCategory(int catId) async {
    final url = Uri.parse(_baseUrl);
    final res = await http.get(url);

    if (res.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(res.body);

    return data
        .where((p) => p["category"]["id"] == catId)
        .map((p) => ProductModel.fromMap(p))
        .toList();
  }
}
