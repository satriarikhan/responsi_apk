
import 'package:flutter/material.dart';
import 'package:responsi_apk/models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => _products;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadProduct() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _api.fetchProduct();
      _products = res;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Product> fetchDetail(int malId) => _api.fetchProductDetail(malId);
}