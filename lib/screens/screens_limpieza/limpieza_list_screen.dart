import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:home_expert_front/model/limpieza_model.dart';
import 'package:home_expert_front/providers/limpieza_provider.dart';

Future<List<bool>> _isFavorite = Future.value([]);

class LimpiezaListScreen extends StatefulWidget {
  const LimpiezaListScreen({super.key});

  @override
  State<LimpiezaListScreen> createState() => _LimpiezaListScreenState();
}

class _LimpiezaListScreenState extends State<LimpiezaListScreen> {
  late Future<List<Limpieza>> _auxiliarElements;
  String _searchQuery = '';
  bool _searchActive = false;

  String _sexoSeleccionado = "";
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
    //_auxiliarElements = listadoLimpieza;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _auxiliarElements = _getlimpiezaProvider(context).getLimpieza();
      _isFavorite = Future.value([]);
    });
  }

  LimpiezaProvider _getlimpiezaProvider(BuildContext context) {
    return Provider.of<LimpiezaProvider>(context, listen: false);
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      _applyFilters();
    });
  }

  // void _applyFilters() {
  //   setState(() {
  //     _auxiliarElements = _getlimpiezaProvider(context).getLimpieza();
  //     _auxiliarElements = _getlimpiezaProvider.where((element) {
  //       // Filtrar por nombre
  //       bool matchesSearchQuery =
  //           element['id'].toLowerCase().contains(_searchQuery.toLowerCase());

  //       // Filtrar por sexo
  //       bool matchesSexoQuery =
  //           _sexoSeleccionado.isEmpty || element['sexo'] == _sexoSeleccionado;

  //       return matchesSearchQuery && matchesSexoQuery;
  //     }).toList();
  //   });
  // }
  void _applyFilters() {
    setState(() {
      _auxiliarElements = _fetchFilteredLimpieza();
    });
  }

  Future<List<Limpieza>> _fetchFilteredLimpieza() async {
    final limpiezaProvider = _getlimpiezaProvider(context);

    // Obtener la lista de limpieza desde el provider
    List<Limpieza> limpiezaList = await limpiezaProvider.getLimpieza();

    return limpiezaList.where((element) {
      // Filtrar por ID
      bool matchesSearchQuery = _searchQuery.isEmpty ||
          element.id
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      // Verificar si _sexoSeleccionado tiene un valor válido en el enum Sexo
      Sexo? sexoSeleccionadoEnum = sexoValues.map[_sexoSeleccionado];
      // Filtrar por sexo
      bool matchesSexoQuery = _sexoSeleccionado.isEmpty ||
          (sexoSeleccionadoEnum != null &&
              element.sexo == sexoSeleccionadoEnum);

      return matchesSearchQuery && matchesSexoQuery;
    }).toList();
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
                  _sexoSeleccionado = sexo;
                  _applyFilters();
                });
              },
            ), // Búsqueda por sexo
            listItemsArea(), // Lista de elementos
          ],
        ),
      ),
    );
  }

  DateTime calcularFechaNacimiento(int edad) {
    DateTime now = DateTime.now();
    int anioNacimiento = now.year - edad;
    return DateTime(anioNacimiento, now.month, now.day);
  }

  int calcularEdad(DateTime fechaNacimiento) {
    DateTime now = DateTime.now();
    int edad = now.year - fechaNacimiento.year;

    // Ajusta si no ha pasado el cumpleaños este año
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      edad--;
    }

    return edad;
  }

  //Lista de elementos
  Expanded listItemsArea() {
    return Expanded(
        child: FutureBuilder<List<Limpieza>>(
      future:
          _auxiliarElements, // Asume que este es el Future<List<Limpieza>> que ya tienes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No hay personal de limpieza disponibles.'));
        }

        final limpieza = snapshot.data!;

        return FutureBuilder<List<bool>>(
          future: _isFavorite, // Este es el Future que estamos esperando
          builder: (context, favoriteSnapshot) {
            if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (favoriteSnapshot.hasError) {
              return Center(child: Text('Error: ${favoriteSnapshot.error}'));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: limpieza.length,
              itemBuilder: (BuildContext context, int index) {
                final element = limpieza[index];
                final avatar = 'assets/avatars/avatar$index.png';

                DateTime fechaNacimiento =
                    calcularFechaNacimiento(element.edad);
                int edad = calcularEdad(fechaNacimiento);

                final isFavorite = (favoriteSnapshot.data ??
                    List.filled(limpieza.length, false))[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'perfil_experto_item',
                      arguments: <String, dynamic>{
                        'avatar': element.foto,
                        'name': element.nombre,
                        'precio': element.precio,
                        'disponibilidad': element.disponible,
                        'fecha_nacimiento': fechaNacimiento.toString(),
                        'calificacion': element.calificacion.toString(),
                        'sexo': element.sexo,
                      },
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onLongPress: () {
                    setState(() {
                      _isFavorite = Future.value(
                        List.generate(limpieza.length, (i) => i == index),
                      );
                    });
                    log('Elemento $index marcado como favorito');
                  },
                  child: Container(
                    height: 120,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFavorite
                          ? Colors.yellow.shade200
                          : Colors.grey.shade200, // Usa isFavorite directamente
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
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Edad: $edad',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(100, 1, 112, 122),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          element.disponible
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: element.disponible ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons
                                  .favorite_border, // Usa isFavorite directamente
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            //final isFavoriteList = favoriteSnapshot.data ?? List.filled(limpieza.length, false);

            // return ListView.builder(
            //   physics: const BouncingScrollPhysics(),
            //   itemCount: limpieza.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     final element = limpieza[index];
            //     final avatar = 'assets/avatars/avatar$index.png';

            //     // Convertir la edad a fecha de nacimiento
            //     DateTime fechaNacimiento =
            //         calcularFechaNacimiento(element.edad);
            //     int edad = calcularEdad(fechaNacimiento);

            //     return GestureDetector(
            //       onTap: () {
            //         Navigator.pushNamed(
            //           context,
            //           'perfil_experto_item',
            //           arguments: <String, dynamic>{
            //             'avatar': element.foto,
            //             'name': element.nombre,
            //             'precio': element.precio,
            //             'disponibilidad': element.disponible,
            //             'fecha_nacimiento': fechaNacimiento.toString(),
            //             'calificacion': element.calificacion.toString(),
            //             'sexo': element.sexo,
            //           },
            //         );
            //         FocusManager.instance.primaryFocus?.unfocus();
            //       },
            //       onLongPress: () {
            //         setState(() {
            //           // _isFavorite[index] = !_isFavorite[index];
            //           _isFavorite = Future.value(
            //             List.generate(limpieza.length, (i) => i == index),
            //           );
            //         });
            //         log('Elemento $index marcado como favorito');
            //       },
            //       child: Container(
            //         height: 120,
            //         margin:
            //             const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //         padding: const EdgeInsets.all(12),
            //         decoration: BoxDecoration(
            //           color: Colors.grey.shade200,
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Colors.black12,
            //               blurRadius: 10,
            //               spreadRadius: 2,
            //               offset: Offset(0, 6),
            //             )
            //           ],
            //         ),
            //         child: Row(
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(30),
            //               child: Image.asset(
            //                 avatar, // Esto depende de cómo manejes los avatares
            //                 width: 60,
            //                 height: 60,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             const SizedBox(width: 12),
            //             Expanded(
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     element
            //                         .nombre, // Usar 'nombre' de 'Limpieza' aquí
            //                     style: const TextStyle(
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.black),
            //                   ),
            //                   Text(
            //                     'Edad: $edad', // Muestra la edad calculada aquí
            //                     style: const TextStyle(
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.bold,
            //                         color: Color.fromARGB(100, 1, 112, 122)),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Icon(
            //               element.disponible
            //                   ? Icons.check_circle
            //                   : Icons.cancel,
            //               color: element.disponible ? Colors.green : Colors.red,
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // );
          },
        );
      },
    ));
  }

//   Expanded listItemsArea() {
//     return Expanded(
//       child: FutureBuilder<List<Limpieza>>(
//         future: _auxiliarElements,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//                 child: Text('No hay personal de limpieza disponibles.'));
//           }

//           final limpieza = snapshot.data!;

//           return ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             itemCount: limpieza.length,
//             itemBuilder: (BuildContext context, int index) {
//               final element = limpieza[index];
//               final avatar = 'assets/avatars/avatar$index.png';

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     'perfil_experto_item',
//                     arguments: <String, dynamic>{
//                       'avatar': element.foto,
//                       'name': element.nombre,
//                       'precio': element.precio.toString(),
//                       'disponibilidad': element.disponible,
//                       'calificacion': element.calificacion,
//                       'sexo': element.sexo,
//                     },
//                   );
//                   FocusManager.instance.primaryFocus?.unfocus();
//                 },
//                 onLongPress: () {
//                   setState(() {
//                     _isFavorite[index] = !_isFavorite[index];
//                   });
//                   log('Elemento $index marcado como favorito: ${_isFavorite[index]}');
//                 },
//                 child: Container(
//                   height: 120,
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: Offset(0, 6),
//                       )
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(30),
//                         child: Image.asset(
//                           avatar,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               element.name, // Ahora se usa el 'name' correcto.
//                               style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                             Text(
//                               element
//                                   .oficio, // Aquí también corregí para usar 'oficio'.
//                               style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(100, 1, 112, 122)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         element.disponibilidad
//                             ? Icons.check_circle
//                             : Icons.cancel,
//                         color:
//                             element.disponibilidad ? Colors.green : Colors.red,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

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
