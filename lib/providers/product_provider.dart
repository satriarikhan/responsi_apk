import 'package:flutter/material.dart';
import 'package:responsi_apk/models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  // Optional feature properties
  List<String> _categories = [];
  String? _selectedCategory;

  // Mengembalikan daftar produk yang sudah difilter [cite: 333]
  List<Product> get products {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _products;
    }
    // Implementasi logika filter
    return _products.where((p) => p.category == _selectedCategory).toList();
  }
  
  List<String> get categories => ['All', ..._categories];
  String? get selectedCategory => _selectedCategory;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadProduct() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _api.fetchProduct(); // Mengambil dan mem-parsing data [cite: 313]
      _products = res;
      // Muat kategori untuk fitur opsional
      _categories = await _api.fetchCategories();
      _selectedCategory = 'All'; // Inisialisasi filter
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Logic untuk memfilter berdasarkan kategori
  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<Product> fetchDetail(int id) => _api.fetchProductDetail(id);
}