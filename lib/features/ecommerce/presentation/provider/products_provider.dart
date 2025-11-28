import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/product_datasource.dart';

class ProductProvider extends ChangeNotifier {
  final _api = ProductDatasource();

  List<ProductModel> products = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  int? lastCategoryId;

  Future<void> fetchProductsByCategory(int? categoryId) async {
    print('rr');

    if (categoryId == null || categoryId <= 0) {
      products = [];
      hasError = true;
      errorMessage = "Categoría inválida";
      notifyListeners();
      return;
    }

    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      var data = await _api.getProductsByCategory(categoryId);
      products = data;
      lastCategoryId = categoryId;
    } catch (e) {
      hasError = true;
      errorMessage = "Error al cargar productos";
      products = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearProducts() {
    products = [];
    lastCategoryId = null;
    hasError = false;
    errorMessage = "";
    notifyListeners();
  }
}
