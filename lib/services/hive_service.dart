import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveService {
  static Box get usersBox => Hive.box('users');
  static Box get cartBox => Hive.box('Cart');

  Future<bool> register(UserModel user) async {
    final box = usersBox;
    if (box.containsKey(user.username)) return false;
    await box.put(user.username, user.toMap());
    return true;
  }

  UserModel? getUser(String username) {
    final box = usersBox;
    final m = box.get(username);
    if (m == null) return null;
    return UserModel.fromMap(Map<dynamic, dynamic>.from(m));
  }

  Future<void> saveUser(UserModel user) async {
    final box = usersBox;
    await box.put(user.username, user.toMap());
  }

  List<int> getCarts() {
    final box = cartBox;
    final list = box.get('cart_list', defaultValue: <int>[]);
    return List<int>.from(list);
  }

  Future<void> saveCarts(List<int> ids) async {
    final box = cartBox;
    await box.put('cart_list', ids);
  }
}