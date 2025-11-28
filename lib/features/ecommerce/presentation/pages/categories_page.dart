import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    Future.microtask(() {
      if (!provider.isLoading && provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildListView(context, provider);
          }

          if (constraints.maxWidth < 1000) {
            return _buildGrid(context, provider, crossAxis: 3);
          }

          return _buildGrid(context, provider, crossAxis: 5);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.fetchCategories,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildListView(BuildContext context, CategoryProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: provider.categories.length,
      itemBuilder: (_, i) {
        final cat = provider.categories[i];

        return ListTile(
          onTap: () => context.go('/products/${cat.id}'),

          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                sanitizeUrl(cat.image),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 32),
              ),
            ),
          ),
          title: Text(cat.name),
          subtitle: Text(cat.slug),
        );
      },
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
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        final cat = provider.categories[i];

        return InkWell(
          onTap: () => context.go('/products/${cat.id}'),

          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      sanitizeUrl(cat.image),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 32),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        cat.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(cat.slug, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
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
