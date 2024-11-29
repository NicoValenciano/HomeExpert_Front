import 'dart:developer';
import 'package:flutter/material.dart';
import '../../mocks/limpieza_mock.dart' show listadoLimpieza;

class LimpiezaListScreen extends StatefulWidget {
  const LimpiezaListScreen({super.key});

  @override
  State<LimpiezaListScreen> createState() => _LimpiezaListScreenState();
}

class _LimpiezaListScreenState extends State<LimpiezaListScreen> {
  List<Map<String, dynamic>> _auxiliarElements = [];
  String _searchQuery = '';
  bool _searchActive = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _auxiliarElements = listadoLimpieza;
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
        _auxiliarElements = listadoLimpieza;
      } else {
        _auxiliarElements = listadoLimpieza.where((element) {
          return element['id']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();
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
            _searchArea(),
            _listItemsArea(),
          ],
        ),
      ),
    );
  }

  AnimatedSwitcher _searchArea() {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
      child: (_searchActive)
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
                      decoration: InputDecoration(
                        hintText: 'Buscar persona de limpieza...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  const Text(
                    'Limpieza',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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

  Expanded _listItemsArea() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElements.length,
        itemBuilder: (BuildContext context, int index) {
          final element = _auxiliarElements[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'limpieza_item',
                arguments: <String, dynamic>{
                  'nombre': element['nombre'],
                  'apellido': element['apellido'],
                  'foto': element['foto'],
                  'edad': element['edad'],
                  'sexo': element['sexo'],
                  'disponible': element['disponible'],
                  'precio': element['precio'],
                  'calificacion': element['calificacion'],
                  'id': element['id'],
                },
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onLongPress: () {
              log('onLongPress $index');
            },
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 6))
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/avatars/${element['foto']}.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element['id'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          element['nombre'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Precio: \$${element['precio']}'),
                        Text(
                          element['apellido'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Apellido: \$${element['apellido']}'),
                      ],
                    ),
                  ),
                  Icon(
                    element['disponibilidad']
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: element['disponibilidad'] ? Colors.teal : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${element['calificacion']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
