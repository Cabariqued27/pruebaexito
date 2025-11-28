import 'package:go_router/go_router.dart';
import 'package:pruebaexito/features/ecommerce/presentation/pages/categories_page.dart';
import 'package:pruebaexito/features/ecommerce/presentation/pages/products_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const CategoriesPage()),
    GoRoute(
      path: '/products/:categoryId',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['categoryId']!);
        return ProductsPage(categoryId: id);
      },
    ),
  ],
);
