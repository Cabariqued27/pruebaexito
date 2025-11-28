import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/product_datasource.dart';

class ProductProvider extends ChangeNotifier {
  final _api = ProductDatasource();

  List<ProductModel> products = [];
  bool isLoading = false;

  int? lastCategoryId;

  Future<void> fetchProductsByCategory(int categoryId) async {
    print('uu');
    if (lastCategoryId == categoryId && products.isNotEmpty) return;

    lastCategoryId = categoryId;
    isLoading = true;
    products = [];
    notifyListeners();

    products = await _api.getProductsByCategory(categoryId);

    isLoading = false;
    notifyListeners();
  }

  void clearProducts() {
    products = [];
    lastCategoryId = null;
    notifyListeners();
  }
}
