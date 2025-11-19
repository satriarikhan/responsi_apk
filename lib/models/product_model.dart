class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      // Ambil 'price' langsung
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      // Ganti 'synopsis' dengan 'description'
      description: json['description'] ?? '', 
      // Ganti 'status' dengan 'category'
      category: json['category'] ?? '', 
      // Ganti 'image'['jpg'] dengan 'image'
      image: json['image'] ?? '', 
      // Ambil nilai 'rate' dari objek 'rating'
      rating: (json['rating']?['rate'] is num) ? (json['rating']['rate'] as num).toDouble() : 0.0,
    );
  }
}