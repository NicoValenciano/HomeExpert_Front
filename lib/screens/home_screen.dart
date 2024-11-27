//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/screens.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Screen'),
//         centerTitle: true,
//         leadingWidth: 40,
//         toolbarHeight: 80,
//       ),
//       drawer: DrawerMenu(),
//       body: const Center(child: Text('Hola mundo')),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.plus_one),
//         onPressed: () {
//           log('click button');
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }
// }

final List<Map<String, String>> cardData = [
  {
    'image': 'assets/images/paseador.png',
    'title': 'Paseadores',
  },
  {
    'image': 'assets/images/jardineros.png',
    'title': 'Jardineros',
  },
  {
    'image': 'assets/images/limpieza.png',
    'title': 'Limpieza',
  },
  {
    'image': 'assets/images/cuidadores.png',
    'title': 'Cuidadores',
  },
  {
    'image': 'assets/images/mantenimiento.png',
    'title': 'Mantenimiento',
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Expert',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'assets/fonts/OoohBaby-regular.ttf')),
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardPromociones(),
            Slogan(size: size),
            const Categorias(),
          ],
        ),
      ),
    );
  }
}

class Categorias extends StatelessWidget {
  const Categorias({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: cardData.length,
      itemBuilder: (context, index) {
        return CardScreen(
          imagePath: cardData[index]['image']!,
          title: cardData[index]['title']!,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Slogan extends StatelessWidget {
  Size size;

  Slogan({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.2,
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 197, 197, 197).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: const Text(
        'Excelencia en cada rincón, expertos en tu hogar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 134, 133, 133),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
