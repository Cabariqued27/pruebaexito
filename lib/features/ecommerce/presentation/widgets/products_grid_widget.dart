import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/products_provider.dart';
import 'product_card_widget.dart';

class ProductsGridWidget extends StatelessWidget {
  final ProductsProvider provider;
  const ProductsGridWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 5;
        }

        double cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;
        double cardHeight = 350;
        double ratio = cardWidth / cardHeight;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: ratio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (_, i) =>
              ProductCardWidget(product: provider.products[i], aspectRatio: ratio),
        );
      },
    );
  }
}
