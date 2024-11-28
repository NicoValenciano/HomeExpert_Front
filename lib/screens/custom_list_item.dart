import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos pasados
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    // Accede a cada argumento con su clave
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil del experto'),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfileCustomItem(
              size: size,
              avatar: args['avatar'],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: BodyProfileCustomItem(args: args),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyProfileCustomItem extends StatelessWidget {
  final bool darkMode = false;
  final Map<String, dynamic> args;

  const BodyProfileCustomItem({super.key, required this.args});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: const Text('Disponibilidad'),
            trailing: Icon(
              args['disponibilidad'] ?? false
                  ? Icons.check_circle
                  : Icons.cancel,
              color:
                  args['disponibilidad'] ?? false ? Colors.green : Colors.red,
            ),
          ),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nombre',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(args['name'] ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fecha de Nacimiento',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(args['fecha_nacimiento'] ?? '',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Precio',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('\$${args['precio'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
                const Icon(Icons.attach_money, color: Colors.green),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calificación',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index <
                                  (double.parse(
                                              args['calificacion'].toString()) /
                                          2)
                                      .round()
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('${args['calificacion']}/10',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sexo',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(args['sexo'] ?? '',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Icon(
                  args['sexo'] == 'male' ? Icons.male : Icons.female,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration decorationInput(
      {IconData? icon, String? hintText, String? helperText, String? label}) {
    return InputDecoration(
      fillColor: Colors.black,
      label: Text(label ?? ''),
      hintText: hintText,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 16),
      prefixIcon: (icon != null) ? Icon(icon) : null,
    );
  }
}

class HeaderProfileCustomItem extends StatelessWidget {
  final Size size;
  final String? avatar;

  const HeaderProfileCustomItem({
    super.key,
    this.avatar,
    required this.size,
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
          child: avatar != ""
              ? Image.asset('assets/avatars/$avatar.png')
              : Image.asset('assets/images/avatar.png'),
        ),
      ),
    );
  }
}
