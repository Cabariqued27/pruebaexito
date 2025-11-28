import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/category_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/category_datasource.dart';

class CategoryProvider with ChangeNotifier {
  final _api = CategoryDatasource();

  List<CategoryModel> categories = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    print('cc');
    try {
      isLoading = true;
      notifyListeners();

      categories = await _api.getCategories();
    } catch (e) {
      debugPrint("Error cargando categorías: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
