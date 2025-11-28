import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/cart_provider.dart';

class CartButtonWidget extends StatelessWidget {
  final int productId;
  const CartButtonWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.productCount(productId);
        final buttonColor = cart.isExpress ? Colors.blue : Colors.orange;

        if (quantity == 0) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => cart.addProduct(productId),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Agregar', style: TextStyle(fontSize: 14)),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => cart.removeProduct(productId),
                icon: Icon(
                  cart.expressEnabled ? Icons.delete_outline : Icons.remove,
                  color: buttonColor,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                quantity.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: buttonColor),
              ),
              IconButton(
                onPressed: () => cart.addProduct(productId),
                icon: Icon(Icons.add, color: buttonColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }
}
