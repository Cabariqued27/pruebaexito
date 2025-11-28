import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> cart = {};
  final Map<int, int> expressCart = {};
  bool expressEnabled = false;

  CartProvider() {
    _loadCart();
  }

  bool get canUseExpress {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 10, 0);
    final end = DateTime(now.year, now.month, now.day, 16, 0);
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get showExpressSwitcher => canUseExpress;
  bool get isExpress => expressEnabled && canUseExpress;

  void toggleExpress(bool value) {
    expressEnabled = value;
    _saveCart(); // Guardar estado del express
    notifyListeners();
  }

  Map<int, int> get activeCart => isExpress ? expressCart : cart;

  void addProduct(int productId) {
    activeCart.update(productId, (q) => q + 1, ifAbsent: () => 1);
    _saveCart();
    notifyListeners();
  }

  void removeProduct(int productId) {
    if (!activeCart.containsKey(productId)) return;

    if (activeCart[productId] == 1) {
      activeCart.remove(productId);
    } else {
      activeCart[productId] = activeCart[productId]! - 1;
    }

    _saveCart();
    notifyListeners();
  }

  int get totalItems => activeCart.values.fold(0, (sum, v) => sum + v);
  int productCount(int productId) => activeCart[productId] ?? 0;

  /// 🔹 Guardar carrito en SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final cartStringMap = cart.map((key, value) => MapEntry(key.toString(), value));
    final expressStringMap = expressCart.map((key, value) => MapEntry(key.toString(), value));

    await prefs.setString('cart', jsonEncode(cartStringMap));
    await prefs.setString('expressCart', jsonEncode(expressStringMap));
    await prefs.setBool('expressEnabled', expressEnabled);
  }

  /// 🔹 Cargar carrito de SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final cartJson = prefs.getString('cart');
    final expressJson = prefs.getString('expressCart');
    expressEnabled = prefs.getBool('expressEnabled') ?? false;

    if (cartJson != null) {
      final decoded = jsonDecode(cartJson) as Map<String, dynamic>;
      cart.clear();
      decoded.forEach((key, value) {
        cart[int.parse(key)] = value;
      });
    }

    if (expressJson != null) {
      final decoded = jsonDecode(expressJson) as Map<String, dynamic>;
      expressCart.clear();
      decoded.forEach((key, value) {
        expressCart[int.parse(key)] = value;
      });
    }

    notifyListeners();
  }
}
