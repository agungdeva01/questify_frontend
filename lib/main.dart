import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/reward_provider.dart';
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

        // ProxyProvider untuk QuestProvider
        ChangeNotifierProxyProvider<HomeProvider, QuestProvider>(
          create: (ctx) => QuestProvider(ctx.read<HomeProvider>()),
          update: (ctx, homeProvider, previous) =>
              previous ?? QuestProvider(homeProvider),
        ),

        // ProxyProvider untuk RewardProvider
        ChangeNotifierProxyProvider<HomeProvider, RewardProvider>(
          create: (ctx) => RewardProvider(ctx.read<HomeProvider>()),
          update: (ctx, homeProvider, previous) =>
              previous ?? RewardProvider(homeProvider),
        ),

        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Questify',
        theme: AppTheme.dungeonTheme,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const LoginScreen(),
      ),
    );
  }
}
