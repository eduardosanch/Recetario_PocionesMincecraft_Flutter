import 'package:flutter/material.dart';

import 'core/facades/potion_facade.dart';
import 'core/factories/app_service_factory.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final facade = AppServiceFactory.potionFacade();
  await facade.init();

  runApp(MyApp(facade: facade));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.facade});

  final PotionFacade facade;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pociones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: facade.isAuthenticated()
          ? HomeScreen(facade: facade)
          : LoginScreen(facade: facade),
      routes: {
        '/login': (context) => LoginScreen(facade: facade),
        '/home': (context) => HomeScreen(facade: facade),
      },
    );
  }
}