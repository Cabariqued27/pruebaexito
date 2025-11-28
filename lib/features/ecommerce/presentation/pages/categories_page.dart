import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/cart_icon_widget.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/categories_grid_widget.dart';
import 'package:pruebaexito/features/ecommerce/presentation/widgets/express_switcher_widget.dart';

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
      final provider = Provider.of<CategoriesProvider>(context, listen: false);
      if (!provider.isLoading && provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
        actions: const [Padding(padding: EdgeInsets.only(right: 16.0), child: CartIconWidget())],
      ),
      body: Column(
        children: [
          const ExpressSwitcherWidget(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth < 600
                    ? 2
                    : (constraints.maxWidth < 1000 ? 3 : 5);
                return CategoriesGridWidget(provider: provider, crossAxisCount: crossAxisCount);
              },
            ),
          ),
        ],
      ),
    );
  }
}
