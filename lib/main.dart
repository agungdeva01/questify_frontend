import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/login_screen.dart'; // Nanti kita buat file ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContextcontext) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Questify',
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(), // Halaman utama langsung ke login
      ),
    );
  }
}
