import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/products_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/cart_provider.dart';
import 'package:pruebaexito/features/ecommerce/data/models/product_model.dart';

class ProductsPage extends StatefulWidget {
  final int? categoryId;
  const ProductsPage({super.key, required this.categoryId});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().fetchProductsByCategory(widget.categoryId);
    });
  }

  String _getCategoryName() {
    final categoryProvider = context.watch<CategoriesProvider>();
    final category = categoryProvider.categories.firstWhere(
      (cat) => cat.id == widget.categoryId,
      orElse: () => categoryProvider.categories.first,
    );
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryName()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ProductsProvider>().clearProducts();
            context.pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: cart.isExpress ? Colors.blue : Colors.orange,
                      size: 30,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            cart.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(child: Text(provider.errorMessage));
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text("No hay productos"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return _buildGrid(provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildGrid(ProductsProvider provider) {
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
          itemBuilder: (_, i) {
            final ProductModel p = provider.products[i];
            final image = (p.images.isNotEmpty && p.images[0].isNotEmpty)
                ? p.images[0]
                : "https://placehold.co/400x400";

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${p.price.toStringAsFixed(2)}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          _buildCartButton(p.id),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCartButton(int productId) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.productCount(productId);
        final isExpress = cart.isExpress;
        final buttonColor = isExpress ? Colors.blue : Colors.orange;

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
                icon: Icon(Icons.delete_outline, color: buttonColor),
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
