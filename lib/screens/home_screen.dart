import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_base/providers/people_provider.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';
import 'package:flutter_application_base/screens/custom_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre
            Text(
              peopleProvider.nombre, // Muestra el nombre
              style: const TextStyle(fontSize: 18),
            ),
            // Apellido
            Text(
              peopleProvider.apellido, // Muestra el apellido
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80,
      ),
      drawer: DrawerMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hola mundo'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomListScreen(),
                ),
              );
              log('Botón Mantenimiento presionado');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Mantenimiento', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () {
          log('click button');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
