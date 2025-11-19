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

    // Mengambil data list produk yang telah masuk ke keranjang [cite: 323]
    final cartIds = cartProv.carts;
    final list = productProv.products.where((a) => cartIds.contains(a.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Perbaikan pop
          },
        ),
      ),
      body: list.isEmpty
          ? const Center(child: Text('No carts yet'))
          // Menampilkan daftar produk (gambar, judul, harga) [cite: 324]
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
                return ProductCard( // Perbaikan: menggunakan ProductCard
                  product: a,
                  isCart: true,
                  onFavToggle: () => cartProv.toggleCart(a.id),
                  // Navigasi ke Halaman Detail saat produk di keranjang di-klik [cite: 325]
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(product: a)), // Perbaikan: parameter 'product'
                  ),
                );
              },
            ),
    );
  }
}