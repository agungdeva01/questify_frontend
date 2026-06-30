import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/profile_provider.dart';
import 'core/theme.dart';
import 'core/app_router.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Questify',
        theme: AppTheme.dungeonTheme,
        debugShowCheckedModeBanner: false,
        // [SECURITY] navigatorKey memungkinkan 401 Interceptor melakukan
        // pushAndRemoveUntil ke LoginScreen tanpa memerlukan BuildContext
        navigatorKey: navigatorKey,
        home: const LoginScreen(), // Pintu masuk aman: selalu mulai dari Login
      ),
    );
  }
}
