import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final List<dynamic> data; // Datos del elemento seleccionado

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data[1]),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderDetail(size: size, avatar: data[0]),
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
  final List<dynamic> data;

  const BodyDetail({super.key, required this.data});

  @override
  BodyDetailState createState() => BodyDetailState();
}

class BodyDetailState extends State<BodyDetail> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.data[4];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(label: 'Nombre:', value: widget.data[1]),
        _buildRow(label: 'Ocupación:', value: widget.data[2]),
        _buildRow(label: 'Edad:', value: widget.data[3].toString()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.star, size: 30),
              const SizedBox(width: 10),
              const Text('Es favorito:', style: TextStyle(fontSize: 18)),
              Checkbox(
                value: isFavorite,
                onChanged: (bool? newValue) {
                  setState(() {
                    isFavorite = newValue ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
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
          backgroundImage: AssetImage('assets/avatars/$avatar.png'),
        ),
      ),
    );
  }
}
