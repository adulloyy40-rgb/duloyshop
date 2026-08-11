import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/product/presentation/pages/product_list_page.dart';
import '../features/product/presentation/pages/product_detail_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailPage(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/category/:category',
        builder: (context, state) => ProductListPage(
          category: state.pathParameters['category'],
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
    ],
  );
}
