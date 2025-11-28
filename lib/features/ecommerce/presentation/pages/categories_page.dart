import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/cart_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      if (!provider.isLoading && provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
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
      body: Column(
        children: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (!cart.showExpressSwitcher) {
                return const SizedBox.shrink();
              }

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
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;

                if (constraints.maxWidth < 600) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth < 1000) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 5;
                }

                return _buildGrid(context, provider, crossAxis: crossAxisCount);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.fetchCategories,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, CategoryProvider provider, {required int crossAxis}) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxis,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        final cat = provider.categories[i];

        return InkWell(
          onTap: () => context.push('/products/${cat.id}'),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      sanitizeUrl(cat.image),
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
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 32),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cat.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat.slug,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String sanitizeUrl(String url) {
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }
    return "https://$url";
  }
}
