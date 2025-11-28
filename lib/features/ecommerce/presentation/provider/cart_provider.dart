import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> cart = {};
  final Map<int, int> expressCart = {};

  bool expressEnabled = false;

  bool get canUseExpress {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 1, 0);
    final end = DateTime(now.year, now.month, now.day, 23, 60);

    return now.isAfter(start) && now.isBefore(end);
  }

  bool get showExpressSwitcher => canUseExpress;

  bool get isExpress => expressEnabled && canUseExpress;

  void toggleExpress(bool value) {
    expressEnabled = value;
    notifyListeners();
  }

  Map<int, int> get activeCart => isExpress ? expressCart : cart;

  void addProduct(int productId) {
    activeCart.update(productId, (q) => q + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeProduct(int productId) {
    if (!activeCart.containsKey(productId)) return;

    if (activeCart[productId] == 1) {
      activeCart.remove(productId);
    } else {
      activeCart[productId] = activeCart[productId]! - 1;
    }

    notifyListeners();
  }

  int get totalItems => activeCart.values.fold(0, (sum, v) => sum + v);

  int productCount(int productId) => activeCart[productId] ?? 0;
}
