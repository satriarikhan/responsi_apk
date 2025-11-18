import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_apk/models/product_model.dart';

class ApiService {
  static const String base = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProduct() async {
    final url = Uri.parse('$base/products');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final List data = body['data'] ?? [];
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top anime');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final url = Uri.parse('$base/products/$id/full');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final data = body['data'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load anime detail');
    }
  }
}