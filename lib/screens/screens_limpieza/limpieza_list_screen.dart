import 'package:flutter/material.dart';
import 'dart:developer';


import 'package:home_expert_front/model/limpieza_model.dart';
import 'package:home_expert_front/providers/limpieza_provider.dart';
import 'package:provider/provider.dart';
import '../../mocks/limpieza_mock.dart' show listadoLimpieza;

List<bool> _isFavorite = [];


class LimpiezaListScreen extends StatefulWidget {
  const LimpiezaListScreen({super.key});

  @override
  State<LimpiezaListScreen> createState() => _LimpiezaListScreenState();
}

class _LimpiezaListScreenState extends State<LimpiezaListScreen> {

  late Future<List<Limpieza>> _auxiliarElements;
  List<bool> _isFavorite = [];

  List<Map<String, dynamic>> _auxiliarElements = [];
  String _searchQuery = '';
  bool _searchActive = false;

  String _sexoSeleccionado = "";
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _loadData();

    _auxiliarElements = listadoLimpieza;
    _isFavorite = List.generate(_auxiliarElements.length, (index) => false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  void _loadData() {
    _auxiliarElements = _getLimpiezaProvider(context).getLimpieza();
    _auxiliarElements.then((data) {
      setState(() {
        _isFavorite =
            List.generate(data.length, (index) => false); // Inicializa en falso
      });
    }).catchError((error) {
      print("Error al cargar los datos: $error");
    });
  }

  LimpiezaProvider _getLimpiezaProvider(BuildContext context) {
    return Provider.of<LimpiezaProvider>(context, listen: false);
  }


  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      if (_searchQuery.isEmpty) {
        _auxiliarElements =
            _getLimpiezaProvider(context).getLimpieza().then((paseadores) {
          if (_searchQuery.isEmpty) {
            return paseadores;
          } else {
            return paseadores.where((element) {
              return element.id
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();
          }
        });
      }
    });
  }


  void _applyFilters(String sexo) {
    setState(() {
      _sexoSeleccionado = sexo;
      _auxiliarElements =
          _getLimpiezaProvider(context).getLimpieza().then((limpieza) {
        return limpieza.where((element) {
          return element.sexo == _sexoSeleccionado;
        }).toList();
      });

  void _applyFilters() {
    setState(() {
      _auxiliarElements = listadoLimpieza.where((element) {
        // Filtrar por nombre
        bool matchesSearchQuery =
            element['id'].toLowerCase().contains(_searchQuery.toLowerCase());

        // Filtrar por sexo
        bool matchesSexoQuery =
            _sexoSeleccionado.isEmpty || element['sexo'] == _sexoSeleccionado;

        return matchesSearchQuery && matchesSexoQuery;
      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          children: [
            searchArea(), // Búsqueda por nombre
            SexoToggleButton(
              onSexoChanged: (sexo) {
                setState(() {
                  _applyFilters(sexo);
                });
              },
            ), // Búsqueda por sexo
            listItemsArea(), // Lista de elementos
          ],
        ),
      ),
    );
  }

  //Lista de elementos
  Expanded listItemsArea() {
    return Expanded(

        child: FutureBuilder<List<Limpieza>>(
            future: _auxiliarElements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar los datos'),
                );
              } else {
                final limpieza = snapshot.data!;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: limpieza.length,
                  itemBuilder: (BuildContext context, int index) {
                    final element = limpieza[index];
                    final avatar = 'assets/avatars/avatar$index.png';

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'perfil_experto_item',
                          arguments: <String, dynamic>{
                            'avatar': avatar,
                            'name': element.nombre,
                            'precio': element.precio,
                            'disponibilidad': element.disponible,
                            'fecha_nacimiento':
                                element.fechaNacimiento.split('T')[0],
                            'calificacion': element.calificacion,
                            'sexo': element.sexo,
                          },
                        );
                      },
                      onLongPress: () {
                        setState(() {
                          _isFavorite[index] = !_isFavorite[index];
                        });
                        log('Elemento $index marcado como favorito: ${_isFavorite[index]}');
                      },
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 6),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                avatar,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    element.nombre,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              element.disponible
                                  ? Icons.event_available_outlined
                                  : Icons.highlight_off,
                              color: element.disponible
                                  ? const Color.fromARGB(255, 1, 158, 30)
                                  : const Color.fromARGB(255, 248, 55, 42),
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                Text(
                                  element.calificacion.toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                const Icon(
                                  Icons.grade,
                                  color: Color.fromARGB(255, 254, 217, 32),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              _isFavorite[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  _isFavorite[index] ? Colors.red : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));

      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElements.length,
        itemBuilder: (BuildContext context, int index) {
          final element = _auxiliarElements[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'perfil_experto_item',
                arguments: <String, dynamic>{
                  'avatar': element['foto'],
                  'name': element['nombreCompleto'],
                  'precio': element['precio'],
                  'disponibilidad': element['disponibilidad'],
                  'fecha_nacimiento': element['fechaNac'].split('T')[0],
                  'calificacion': element['calificacion'],
                  'oficio': element['oficio'],
                  'sexo': element['sexo'],
                },
              );
            },
            onLongPress: () {
              setState(() {
                _isFavorite[index] = !_isFavorite[index];
              });
              log('Elemento $index marcado como favorito: ${_isFavorite[index]}');
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
                    offset: Offset(0, 6),
                  )
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          element['nombreCompleto'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          element['oficio'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(100, 1, 112, 122)),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    element['disponibilidad']
                        ? Icons.event_available_outlined
                        : Icons.highlight_off,
                    color: element['disponibilidad']
                        ? const Color.fromARGB(255, 1, 158, 30)
                        : const Color.fromARGB(255, 248, 55, 42),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        element['calificacion'].toString(),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const Icon(
                        Icons.grade,
                        color: Color.fromARGB(255, 254, 217, 32),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    _isFavorite[index] ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite[index] ? Colors.red : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }

  // Sección de búsqueda
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
                      decoration: const InputDecoration(
                          hintText: 'Buscar por nombre...'),
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
                      FocusManager.instance.primaryFocus?.unfocus();
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
                    icon: const Icon(Icons.keyboard_arrow_left_outlined),
                  ),
                  const Text(
                    'Personas de Limpieza',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchActive = !_searchActive;
                      });
                      _focusNode.requestFocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
    );
  }
}

// Widget de selección de sexo
class SexoToggleButton extends StatefulWidget {
  final Function(String) onSexoChanged;

  const SexoToggleButton({super.key, required this.onSexoChanged});

  @override
  SexoToggleButtonState createState() => SexoToggleButtonState();
}

class SexoToggleButtonState extends State<SexoToggleButton> {
  int _selectedIndex = -1; // Sin selección por defecto

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Buscar por sexo:"),
        ToggleButtons(
          isSelected: [
            _selectedIndex == 0,
            _selectedIndex == 1,
          ],
          onPressed: (int index) {
            setState(() {
              if (_selectedIndex == index) {
                // Si el botón ya está seleccionado, se deselecciona
                _selectedIndex = -1;
              } else {
                _selectedIndex = index;
              }

              String sexo = '';
              if (_selectedIndex == 0) {
                sexo = 'male';
              } else if (_selectedIndex == 1) {
                sexo = 'female';
              } else if (_selectedIndex == 2) {
                sexo = 'other';
              }
              widget.onSexoChanged(sexo);
            });
          },
          borderRadius: BorderRadius.circular(10),
          borderColor: Colors.transparent,
          splashColor: const Color.fromARGB(100, 1, 112, 122),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Masculino",
                style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Femenino",
                style: TextStyle(
                  color: _selectedIndex == 1
                      ? const Color.fromARGB(255, 249, 44, 112)
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
