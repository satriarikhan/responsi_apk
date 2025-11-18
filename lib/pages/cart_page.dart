import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/models/product_model.dart';
import 'package:responsi_apk/pages/detail.page.dart';
import 'package:responsi_apk/providers/cart_provider.dart';
import 'package:responsi_apk/providers/product_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<CartProvider>(context);
    final animeProv = Provider.of<ProductProvider>(context, listen: false);

    final cartIds = CartProv.carts;
    final list = animeProv.products.where((a) => cartIds.contains(a.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); 
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
                return AnimeCard(
                  product: a,
                  isCart: true,
                  onCartToggle: () => cartProv.toggleCart(a.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(anime: a)),
                  ),
                );
              },
            ),
    );
  }
}