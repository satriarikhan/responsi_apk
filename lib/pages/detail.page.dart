import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/models/product_model.dart';
import 'package:responsi_apk/providers/cart_provider.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isCart = false;

  @override
  void initState() {
    super.initState();
    final fav = Provider.of<CartProvider>(context, listen: false);
    _isCart = fav.isCart(widget.product.id);
  }

  String get _formattedPrice => 'Rp ${(widget.product.price * 15000).toStringAsFixed(0)}';

  Future<void> _toggleCart() async {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    await cartProv.toggleCart(widget.product.id);
    setState(() {
      _isCart = !_isCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formattedPrice, // Menampilkan harga
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrangeAccent
                    ),
                  ),
                  const SizedBox(height: 16),
                
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCart ? Colors.red : Colors.deepOrangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      icon: Icon(_isCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                      label: Text(
                        _isCart ? "Remove from Cart" : "Add to Cart",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description.isEmpty
                        ? 'No description available.'
                        : widget.product.description,
                    textAlign: TextAlign.justify,
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Category:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.product.category),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Rating:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(widget.product.rating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}