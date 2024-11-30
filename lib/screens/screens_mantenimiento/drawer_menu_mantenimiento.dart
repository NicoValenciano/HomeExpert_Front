import 'package:flutter/material.dart';
import '../../mocks/mantenimiento_mock.dart'
    show elements, obtenerOficiosUnicos;

class DrawerMenuMantenimiento extends StatelessWidget {
  final Function(String) onOficioSelected;

  const DrawerMenuMantenimiento({
    super.key,
    required this.onOficioSelected,
  });

  @override
  Widget build(BuildContext context) {
    final oficios = obtenerOficiosUnicos(elements);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/mantenimiento.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Oficios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ...oficios.map(
            (oficio) => ListTile(
              leading: const Icon(
                Icons.work_outline,
                color: Colors.blue,
              ),
              title: Text(
                oficio,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onOficioSelected(oficio);
              },
            ),
          ),
        ],
      ),
    );
  }
}
