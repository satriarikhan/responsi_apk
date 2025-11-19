import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/pages/cart_page.dart'; // Import CartPage
import 'package:responsi_apk/pages/detail.page.dart';
import 'package:responsi_apk/pages/profile_page.dart'; // Import ProfilePage
import 'package:responsi_apk/providers/cart_provider.dart';
import 'package:responsi_apk/providers/product_provider.dart';
import 'package:responsi_apk/widgets/bottom_navbar.dart';
import 'package:responsi_apk/widgets/product_card.dart';
import 'package:responsi_apk/widgets/shimmer_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductProvider? _productProv;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Perbaikan: Menggunakan ProductProvider
      _productProv = Provider.of<ProductProvider>(context, listen: false);
      _productProv!.loadProduct();
    });
  }

  Future<void> _refresh() async => await _productProv!.loadProduct();

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // Already on Home
        break;

      case 1:
        // Navigasi ke CartPage (sesuai BottomNavbar)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        ).then((_) {
          if (mounted) {
            setState(() => _currentIndex = 0);
            _productProv!.loadProduct(); // Refresh data saat kembali ke Home
          }
        });
        break;

      case 2:
        // Navigasi ke ProfilePage (sesuai BottomNavbar)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        ).then((_) {
          if (mounted) {
            setState(() => _currentIndex = 0);
          }
        });
        break;
    }
  }

  // Widget untuk Filter Kategori (Optional Feature) [cite: 332]
  Widget _buildFilterChips(ProductProvider productProv) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: productProv.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = productProv.categories[index];
          return FilterChip(
            label: Text(category),
            selected: productProv.selectedCategory == category,
            onSelected: (selected) {
              if (selected) {
                productProv.filterByCategory(category);
              } else {
                productProv.filterByCategory('All');
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Perbaikan: Menggunakan ProductProvider
    final productProv = Provider.of<ProductProvider>(context);
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 10),
              child: Text(
                "Top Products",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // Integrasi Filter Kategori (jika data sudah dimuat)
            if (productProv.categories.isNotEmpty) _buildFilterChips(productProv),
            if (productProv.categories.isNotEmpty) const SizedBox(height: 12),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Builder(builder: (_) {
                if (productProv.loading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, __) => const ShimmerLoading(height: 260),
                  );
                }

                if (productProv.error != null) {
                  return Center(child: Text('Error: ${productProv.error}'));
                }

                // Gunakan daftar produk yang sudah difilter
                final list = productProv.products; 

                if (list.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                // Menampilkan data produk dalam bentuk GridView [cite: 314]
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) {
                    final a = list[idx];
                    return ProductCard(
                      product: a,
                      isCart: cartProv.isCart(a.id),
                      // Mengganti onFavToggle dengan toggleCart dari CartProvider
                      onFavToggle: () => cartProv.toggleCart(a.id),
                      // Navigasi ke Halaman Detail [cite: 316]
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(product: a)),
                      ),
                      // Menghapus parameter yang tidak perlu dari file lama
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}