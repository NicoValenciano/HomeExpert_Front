import 'dart:developer';
import 'package:flutter/material.dart';
import '../../mocks/paseadores_mock.dart' show elementsPaseadores;

class PaseadoresListScreen extends StatefulWidget {
  const PaseadoresListScreen({super.key});
  @override
  State<PaseadoresListScreen> createState() => _PaseadoresListScreenState();
}

class _PaseadoresListScreenState extends State<PaseadoresListScreen> {
  List<Map<String, dynamic>> _auxiliarElementsPaseadores = [];
  String _searchQuery = '';
  bool _searchActive = false;
  bool _showAvailable = true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0; // Índice para el BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _auxiliarElementsPaseadores = elementsPaseadores;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      if (_searchQuery.isEmpty) {
        _auxiliarElementsPaseadores = elementsPaseadores;
      } else {
        _auxiliarElementsPaseadores = elementsPaseadores.where((paseador) {
          return paseador['id']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  // Función para filtrar por disponibilidad
  void _filterAvailable(bool available) {
    setState(() {
      _showAvailable = available;
      _auxiliarElementsPaseadores = elementsPaseadores.where((paseador) {
        return paseador['disponibilidad'] == available;
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        // Mostrar solo disponibles
        _filterAvailable(true);
      } else if (_selectedIndex == 1) {
        // Mostrar solo no disponibles
        _filterAvailable(false);
      } else {
        // Mostrar todos
        _auxiliarElementsPaseadores = elementsPaseadores;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          children: [
            searchArea(),
            listItemsArea(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Disponibles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cancel),
              label: 'No disponibles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Todos',
            ),
          ],
        ),
      ),
    );
  }

  Expanded listItemsArea() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElementsPaseadores.length,
        itemBuilder: (BuildContext context, int index) {
          final paseador = _auxiliarElementsPaseadores[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'custom_list_item',
                arguments: <String, dynamic>{
                  'precio': paseador['precio'],
                  'name': paseador['nombreCompleto'],
                  'sexo': paseador['sexo'],
                  'avatar': paseador['foto'],
                  'disponibilidad': paseador['disponibilidad'],
                  'calificacion': paseador['calificacion'],
                  'fecha_nacimiento': paseador['fechaNacimiento']
                },
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onLongPress: () {
              log('onLongPress $index');
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(31, 22, 78, 189),
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: Offset(0, 6))
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/avatars/${paseador['foto']}.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paseador['id'],
                        ),
                        Text(
                          paseador['nombreCompleto'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text('Precio: \$${paseador['precio']}'),
                      ],
                    ),
                  ),
                  Icon(
                    paseador['disponibilidad']
                        ? Icons.verified
                        : Icons.error_outline,
                    color:
                        paseador['disponibilidad'] ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text('${paseador['calificacion']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AnimatedSwitcher searchArea() {
    return AnimatedSwitcher(
      switchInCurve: Curves.bounceIn,
      switchOutCurve: Curves.bounceOut,
      duration: const Duration(milliseconds: 300),
      child: (_searchActive)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) {
                        _updateSearch(value);
                      },
                      onFieldSubmitted: (value) {
                        _updateSearch(value);
                      },
                      decoration: const InputDecoration(hintText: 'Buscar...'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      _updateSearch('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchActive = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left_outlined)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _searchActive = !_searchActive;
                        });
                        _focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.search)),
                ],
              ),
            ),
    );
  }
}
