import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/cart_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/category_provider.dart';
import 'package:pruebaexito/features/ecommerce/presentation/provider/products_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Prueba Exito",
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
