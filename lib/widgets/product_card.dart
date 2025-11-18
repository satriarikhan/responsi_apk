
import 'package:flutter/material.dart';
import 'package:responsi_apk/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFCartToggle;
  final bool isCart;

  const ProductCard({super.key, required this.product, required this.onTap, required this.onCartToggle, required this.isCart, required this.onFCartToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(product.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(30)),
                          child: Icon(isCart ? Icons.favorite : Icons.favorite_border, color: isCart ? Colors.red : Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(children: [const Icon(Icons.star, size: 14), const SizedBox(width: 6), Text(product.score.toString())]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}