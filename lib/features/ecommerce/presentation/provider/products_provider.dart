import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/product_datasource.dart';

/// Provider encargado de manejar el estado de los productos.

/// Proporciona:
/// - Lista de productos por categoría.
/// - Estado de carga (`isLoading`).
/// - Manejo de errores (`hasError` y `errorMessage`).
/// - Control de la última categoría consultada (`lastCategoryId`).
class ProductsProvider extends ChangeNotifier {
  final _api = ProductDatasource();

  List<ProductModel> products = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  int? lastCategoryId;

  /// Obtiene los productos de una categoría específica.
  /// Parámetros:
  /// - [categoryId]: ID de la categoría a consultar.
  /// Maneja el estado de carga y errores. Si la categoría es inválida,
  /// establece un mensaje de error.
  Future<void> fetchProductsByCategory(int? categoryId) async {
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
      debugPrint("Error cargando productos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Limpia la lista de productos y restablece el estado.
  void clearProducts() {
    products = [];
    lastCategoryId = null;
    hasError = false;
    errorMessage = "";
    notifyListeners();
  }
}
