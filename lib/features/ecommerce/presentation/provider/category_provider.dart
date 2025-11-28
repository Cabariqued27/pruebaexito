import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/category_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/category_datasource.dart';

class CategoryProvider with ChangeNotifier {
  final _api = CategoryDatasource();

  List<CategoryModel> categories = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  Future<void> fetchCategories() async {
    print('siuu');
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final data = await _api.getCategories();

      if (data.isEmpty) {
        hasError = true;
        errorMessage = "No hay categorías disponibles";
      } else {
        categories = data;
      }
    } catch (e) {
      hasError = true;
      errorMessage = "Error al cargar categorías";
      categories = [];
      debugPrint("Error cargando categorías: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
