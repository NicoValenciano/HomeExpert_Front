import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/screens.dart';
import 'package:flutter_application_base/widgets/promo_card_swiper.dart';

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
              fontSize: 30,
              fontFamily: 'DancingScript',
            )),
        backgroundColor: Colors.white,
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Promociones',
          ),
        ],
        backgroundColor: Colors.white,
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

class Slogan extends StatelessWidget {
  final Size size;

  Slogan({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.12,
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: const Text(
        'Excelencia en cada rincón, expertos en tu hogar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
