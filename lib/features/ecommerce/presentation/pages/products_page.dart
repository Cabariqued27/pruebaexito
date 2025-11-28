import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/products_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/cart_icon_widget.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/products_grid_widget.dart';

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
    final productsProvider = context.watch<ProductsProvider>();
    final categoryName = _getCategoryName();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(categoryName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (!productsProvider.isLoading && productsProvider.products.isNotEmpty)
              Text(
                '${productsProvider.products.length} productos',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ProductsProvider>().clearProducts();
            context.pop();
          },
        ),
        actions: const [Padding(padding: EdgeInsets.only(right: 16.0), child: CartIconWidget())],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.hasError) return Center(child: Text(provider.errorMessage));
          if (provider.products.isEmpty) return const Center(child: Text("No hay productos"));

          return ProductsGridWidget(provider: provider);
        },
      ),
    );
  }
}
