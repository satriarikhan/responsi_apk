import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class CartProvider with ChangeNotifier {
  final HiveService _hive = HiveService();
  List<int> _carts = [];

  List<int> get carts => _carts;

  CartProvider() {
    _load();
  }

  void _load() {
    _carts = _hive.getCarts();
    notifyListeners();
  }

  bool isCart(int id) => _carts.contains(id);

  Future<void> addCart(int id) async {
    if (!_carts.contains(id)) {
      _carts.add(id);
      await _hive.saveCarts(_carts);
    }
  }

  Future<void> removeCart(int id) async {
    if (_carts.contains(id)) {
      _carts.remove(id);
      await _hive.saveCarts(_carts);
      notifyListeners();
    }
  }

  Future<void> toggleCart(int id) async {
    if (isCart(id)) {
      await removeCart(id);
    } else {
      await addCart(id);
    }
  }
}