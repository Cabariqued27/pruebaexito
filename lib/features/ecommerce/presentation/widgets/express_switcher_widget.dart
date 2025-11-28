import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/cart_provider.dart';

class ExpressSwitcherWidget extends StatelessWidget {
  const ExpressSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (!cart.showExpressSwitcher) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cart.isExpress ? Colors.blue.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cart.isExpress ? Colors.blue : Colors.orange, width: 2),
          ),
          child: Row(
            children: [
              Icon(Icons.bolt, color: cart.isExpress ? Colors.blue : Colors.orange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Activar la experiencia express',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cart.isExpress ? Colors.blue.shade900 : Colors.orange.shade900,
                  ),
                ),
              ),
              Switch(
                value: cart.expressEnabled,
                onChanged: (value) => cart.toggleExpress(value),
                activeThumbColor: Colors.blue,
                inactiveThumbColor: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}
