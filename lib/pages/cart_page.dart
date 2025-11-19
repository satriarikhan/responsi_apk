import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/pages/detail.page.dart';
import 'package:responsi_apk/providers/cart_provider.dart';
import 'package:responsi_apk/providers/product_provider.dart';
import 'package:responsi_apk/widgets/product_card.dart'; // Perbaikan import

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    final cartIds = cartProv.carts;
    final list = productProv.products.where((a) => cartIds.contains(a.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: list.isEmpty
          ? const Center(child: Text('No carts yet'))
          : GridView.builder(
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
                  isCart: true,
                  onFavToggle: () => cartProv.toggleCart(a.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(product: a)), 
                  ),
                );
              },
            ),
    );
  }
}