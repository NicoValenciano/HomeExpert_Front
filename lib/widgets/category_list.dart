import 'package:flutter/material.dart';
import 'package:home_expert_front/screens/screens.dart';
import 'package:home_expert_front/screens/screens_paseadores/paseadores_list_screen.dart';

class CardScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const CardScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Marco modificacion realizada para funcionalidad de boton en el archivo de cami
      onTap: () {
        if (title == "Mantenimiento") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MantenimientoListScreen()),
          );
        } else if (title == "Cuidadores") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CuidadoresListScreen()),
          );
        } else if (title == "Jardineros") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const JardineriaListScreen()),
          );
        } else if (title == "Limpieza") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LimpiezaListScreen()),
          );
        } else if (title == "Paseadores") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PaseadoresListScreen()),
          );
        }
      }, //termina aca
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10.0,
          margin: const EdgeInsets.all(10.0),
          color: Colors.grey[100],
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(imagePath,
                      width: 150, height: 150, fit: BoxFit.cover),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
