import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/screens.dart';
import 'providers/theme_provider.dart';
import 'package:flutter_application_base/providers/people_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: false)),
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.temaActual,
      initialRoute: 'home', // Ruta inicial
      routes: {
        'home': (context) => const HomeScreen(), // Pantalla principal
        'profile': (context) => const ProfileScreen(), // Pantalla de perfil
      },
    );
  }
}
