import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/product_datasource.dart';

class ProductProvider extends ChangeNotifier {
  final _api = ProductDatasource();

  List<ProductModel> products = [];
  bool isLoading = false;

  int? lastCategoryId;

  Future<void> fetchProductsByCategory(int categoryId) async {
    isLoading = true;
    notifyListeners();
    var data = await _api.getProductsByCategory(categoryId);
    products = data;
    isLoading = false;
    notifyListeners();
  }

  void clearProducts() {
    products = [];
    lastCategoryId = null;
    notifyListeners();
  }
}
