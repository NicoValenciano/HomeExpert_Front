import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/detail_screen.dart';

class CustomListScreen extends StatelessWidget {
  final List _elements = [
    ['avatar1', 'Juan Pérez', 'electricista', 34, true],
    ['avatar2', 'María Gómez', 'plomero', 28, false],
    ['avatar3', 'Carlos López', 'gasista', 41, true],
    ['avatar4', 'Ana Rodríguez', 'carpintero', 37, false],
    ['avatar5', 'Pedro García', 'albañil', 50, true],
    ['avatar6', 'Lucía Martínez', 'jardinero', 29, false],
    ['avatar7', 'José Ramírez', 'pintor', 45, true],
    ['avatar8', 'Sofía Fernández', 'cerrajero', 32, false],
    ['avatar9', 'Diego Morales', 'vidriero', 39, true],
    ['avatar10', 'Laura Torres', 'tapicero', 47, false],
    ['avatar11', 'Martín Ruiz', 'electricista', 33, true],
    ['avatar12', 'Clara Álvarez', 'plomero', 42, false],
    ['avatar13', 'Miguel Sánchez', 'gasista', 36, true],
    ['avatar1', 'Rosa Vega', 'albañil', 30, false],
    ['avatar2', 'Andrés Ortega', 'jardinero', 44, true],
    ['avatar3', 'Patricia Blanco', 'carpintero', 27, false],
    ['avatar4', 'Gabriel Méndez', 'pintor', 51, true],
    ['avatar5', 'Isabel Romero', 'cerrajero', 38, false],
    ['avatar6', 'Alberto Medina', 'vidriero', 35, true],
    ['avatar7', 'Elena Aguirre', 'tapicero', 46, false],
    ['avatar8', 'Marcos Paredes', 'electricista', 31, true],
    ['avatar9', 'Cristina Herrera', 'plomero', 40, false],
    ['avatar10', 'Javier Castro', 'gasista', 49, true],
    ['avatar11', 'Verónica Núñez', 'albañil', 25, false],
    ['avatar12', 'Héctor Peña', 'jardinero', 37, true],
    ['avatar13', 'Mariana Soto', 'carpintero', 29, false],
    ['avatar1', 'Esteban Chávez', 'pintor', 43, true],
    ['avatar2', 'Florencia Ávila', 'cerrajero', 34, false],
    ['avatar3', 'Roberto León', 'vidriero', 28, true],
    ['avatar4', 'Carla Vargas', 'tapicero', 50, false],
    ['avatar5', 'Fernando Reyes', 'electricista', 39, true],
    ['avatar6', 'Julia Benítez', 'plomero', 45, false],
    ['avatar7', 'Ricardo Herrera', 'gasista', 33, true],
    ['avatar8', 'Mónica Díaz', 'albañil', 42, false],
    ['avatar9', 'Guillermo Paz', 'jardinero', 37, true],
    ['avatar10', 'Alejandra Ríos', 'carpintero', 26, false],
    ['avatar11', 'Ramón Cruz', 'pintor', 48, true],
    ['avatar12', 'Valeria Quintana', 'cerrajero', 40, false],
    ['avatar13', 'Tomás Salinas', 'vidriero', 32, true],
    ['avatar1', 'Andrea Molina', 'tapicero', 29, false],
    ['avatar2', 'Sergio Maldonado', 'electricista', 36, true],
    ['avatar3', 'Paula Figueroa', 'plomero', 41, false],
    ['avatar4', 'Luis Campos', 'gasista', 38, true],
    ['avatar5', 'Lorena Silva', 'albañil', 27, false],
    ['avatar6', 'Francisco Acosta', 'jardinero', 49, true],
    ['avatar7', 'Natalia Valdez', 'carpintero', 33, false]
  ];

  CustomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _elements.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(data: _elements[index]),
                ),
              );
              log('onTAP $index');
            },
            onLongPress: () {
              log('onLongPress $index');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/avatars/${_elements[index][0]}.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Información
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _elements[index][1], // Nombre
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _elements[index][2], // Ocupación
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Favorito y Edad
                    Column(
                      children: [
                        Icon(
                          _elements[index][4] ? Icons.star : Icons.star_border,
                          color:
                              _elements[index][4] ? Colors.amber : Colors.grey,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_elements[index][3]} años', // Edad
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
