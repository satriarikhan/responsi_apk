import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsi_apk/pages/home_page.dart';
import 'package:responsi_apk/pages/login_page.dart';
import 'package:responsi_apk/providers/auth_provider.dart';
import 'package:responsi_apk/providers/cart_provider.dart';
import 'package:responsi_apk/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive Flutter
  await Hive.initFlutter();
  // Buka boxes yang diperlukan (users dan Cart)
  await Hive.openBox('users');
  await Hive.openBox('Cart');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema gelap untuk menyesuaikan tampilan yang Anda berikan
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // FutureBuilder untuk menangani inisialisasi sesi
      home: const SessionGate(),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  Future<void> _loadSession() async {
    // Memuat sesi dari Shared Preferences saat aplikasi dimulai
    await Provider.of<AuthProvider>(context, listen: false).loadFromSession();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Periksa status login hanya setelah sesi dimuat
    return FutureBuilder(
      future: _loadSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading screen saat memuat sesi
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
            ),
          );
        }

        // Navigasi berdasarkan status login
        if (authProvider.currentUser != null) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
