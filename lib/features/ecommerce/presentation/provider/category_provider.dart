import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/data/datasources/category_datasource.dart';
import 'package:pruebaexito/features/ecommerce/data/models/category_model.dart';

/// Provider encargado de manejar el estado de las categorías.

/// Proporciona:
/// - Lista de categorías.
/// - Estado de carga (`isLoading`).
/// - Manejo de errores (`hasError` y `errorMessage`).
class CategoriesProvider with ChangeNotifier {
  final _api = CategoryDatasource();

  List<CategoryModel> categories = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  /// Maneja el estado de carga y los posibles errores.
  Future<void> fetchCategories() async {
    isLoading = true;
    hasError = false;
    notifyListeners(); // Notifica que comenzó la carga

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
      notifyListeners(); // Notifica que terminó la carga
    }
  }
}
