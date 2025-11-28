import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/products_provider.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';

class ProductsPage extends StatelessWidget {
  final int categoryId;

  const ProductsPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    Future.microtask(() {
      if (!provider.isLoading && provider.products.isEmpty) {
        provider.fetchProductsByCategory(categoryId);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          if (constraints.maxWidth < 600) {
            return _buildList(provider);
          }

          return _buildGrid(provider);
        },
      ),
    );
  }

  Widget _buildList(ProductProvider provider) {
    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (_, i) {
        final ProductModel p = provider.products[i];

        final image = (p.images.isNotEmpty && p.images[0].isNotEmpty)
            ? p.images[0]
            : "https://placehold.co/200x200";

        return ListTile(
          leading: Image.network(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
          title: Text(p.title),
          subtitle: Text("\$${p.price.toStringAsFixed(2)}"),
        );
      },
    );
  }

  Widget _buildGrid(ProductProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        final ProductModel p = provider.products[i];

        final image = (p.images.isNotEmpty && p.images[0].isNotEmpty)
            ? p.images[0]
            : "https://placehold.co/400x400";

        return Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("\$${p.price.toStringAsFixed(2)}"),
              ),
            ],
          ),
        );
      },
    );
  }
}
