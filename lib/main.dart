import 'package:flutter/material.dart';
import 'package:home_expert_front/providers/provider.dart';
import 'package:home_expert_front/screens/screens.dart';
import 'package:provider/provider.dart';

import 'helpers/preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Necesario antes de usar SharedPreferences en main

  await Preferences.initShared();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkMode: Preferences.darkmode)),
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
        ChangeNotifierProvider(create: (_) => MantenimientoProvider()),
        ChangeNotifierProvider(create: (_) => PaseadoresProvider()),
        ChangeNotifierProvider(create: (_) => CuidadoPersonasProvider()),
        ChangeNotifierProvider(create: (_) => JardineriaProvider())
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
        'profile': (context) =>
            const ProfileScreen(), // Pantalla de perfil de usuario
        'perfil_experto_item': (context) =>
            const PerfilExpertoItem(), // Pantalla de perfil de experto
      },
    );
  }
}
