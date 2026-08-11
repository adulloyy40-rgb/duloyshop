import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DuloyShop'),
        actions: [
          // Pengaturan Server
          IconButton(
            tooltip: 'Pengaturan Server',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings/server');
            },
          ),

          // Keranjang
          IconButton(
            tooltip: 'Keranjang',
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 80,
              ),

              const SizedBox(height: 20),

              const Text(
                'Selamat Datang di DuloyShop',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Temukan berbagai produk terbaik untuk kebutuhan Anda.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/products');
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Lihat Produk'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/settings/server');
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Pengaturan Server'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
