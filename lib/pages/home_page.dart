import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/models/product_model.dart';
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
      _productProv = Provider.of<Product>(context, listen: false);
      _productProv!.loadProduct();
    });
  }

  Future<void> _refresh() async => await _productProv!.loadProduct();

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        ).then((_) {
          
          if (mounted) {
            setState(() => _currentIndex = 0);
          }
        });
        break;

      case 2:
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

  @override
  Widget build(BuildContext context) {
    final ProductProvider = Provider.of<Product>(context);
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
                "Top Anime",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Builder(builder: (_) {
                if (ProductProv.loading) {
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

                if (Product.error != null) {
                  return Center(child: Text('Error: ${Product.error}'));
                }

                final list = Product.product;

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
                      isCart: cartProv.isCart(a.malId),
                      onFavToggle: () => cartProv.toggleCart(a.malId),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(anime: a)),
                      ),
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