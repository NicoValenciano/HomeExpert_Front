import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data; // Datos del elemento seleccionado

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['nombreCompleto']),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderDetail(size: size, avatar: data['foto']),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: BodyDetail(data: data),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const BodyDetail({super.key, required this.data});

  @override
  BodyDetailState createState() => BodyDetailState();
}

class BodyDetailState extends State<BodyDetail> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.data['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Nombre:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                widget.data['nombreCompleto'],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Ocupación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                widget.data['oficio'],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Precio:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${widget.data['precio']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Calificación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                widget.data['calificacion'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 30),
              const SizedBox(width: 10),
              const Text('Es favorito:', style: TextStyle(fontSize: 18)),
              Switch(
                value: isFavorite,
                onChanged: (bool newValue) {
                  setState(() {
                    isFavorite = newValue;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderDetail extends StatelessWidget {
  final Size size;
  final String avatar;

  const HeaderDetail({
    super.key,
    required this.size,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      color: const Color(0xff2d3e4f),
      child: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/m_avatars/$avatar.png'),
        ),
      ),
    );
  }
}
