import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, dynamic>> _menuItems = <Map<String, dynamic>>[
    {'route': 'home', 'title': 'Inicio', 'icon': Icons.home},
    {'route': 'home', 'title': 'Registrarme', 'icon': Icons.person_add},
    {'route': 'home', 'title': 'Buscar', 'icon': Icons.search},
    {'route': 'home', 'title': 'Notificaciones', 'icon': Icons.notifications},
    {'route': 'home', 'title': 'Favoritos', 'icon': Icons.favorite},
    {'route': 'home', 'title': 'Ofertas', 'icon': Icons.local_offer},
    {'route': 'home', 'title': 'Cupones', 'icon': Icons.card_giftcard},
    {'route': 'home', 'title': 'Historial', 'icon': Icons.history},
    {'route': 'profile', 'title': 'Mi Cuenta', 'icon': Icons.account_circle},
    {'route': 'home', 'title': 'Configuración', 'icon': Icons.settings},
    {'route': 'home', 'title': 'Ayuda', 'icon': Icons.help},
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeaderAlternative(),
          ...ListTile.divideTiles(
              context: context,
              tiles: _menuItems
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        dense: true,
                        minLeadingWidth: 25,
                        iconColor: Colors.blueGrey,
                        title: Text(item['title']!,
                            style: const TextStyle(fontFamily: 'FuzzyBubbles')),
                        leading: Icon(item['icon']),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, item['route']!);
                        },
                      ))
                  .toList())
        ],
      ),
    );
  }
}

class _DrawerHeaderAlternative extends StatelessWidget {
  const _DrawerHeaderAlternative();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        child: const Text(
          'HomeExpert',
          style: TextStyle(
              fontSize: 13, color: Colors.black54, fontFamily: 'RobotoMono'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
