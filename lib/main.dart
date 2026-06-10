import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'core/theme.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Questify',
        theme: AppTheme.dungeonTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(), // Halaman utama kita ubah ke HomeScreen untuk testing UI
      ),
    );
  }
}
