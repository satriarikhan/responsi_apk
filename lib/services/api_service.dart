import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_apk/models/product_model.dart';

class ApiService {
  static const String base = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProduct() async {
    final url = Uri.parse('$base/products');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products. Status: ${resp.statusCode}');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final url = Uri.parse('$base/products/$id');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product detail. Status: ${resp.statusCode}');
    }
  }

  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$base/products/categories');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load categories. Status: ${resp.statusCode}');
    }
  }
}