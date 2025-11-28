import 'package:flutter/material.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/category_card_widget.dart';

class CategoriesGridWidget extends StatelessWidget {
  final CategoriesProvider provider;
  final int crossAxisCount;

  const CategoriesGridWidget({super.key, required this.provider, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) => CategoryCardWidget(category: provider.categories[i]),
    );
  }
}
