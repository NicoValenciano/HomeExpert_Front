import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_expert_front/model/mantenimiento_model.dart';
import 'package:home_expert_front/providers/mantenimiento_provider.dart';
import 'package:provider/provider.dart';
import 'drawer_menu_mantenimiento.dart';

class MantenimientoListScreen extends StatefulWidget {
  const MantenimientoListScreen({super.key});

  @override
  State<MantenimientoListScreen> createState() =>
      _MantenimientoListScreenState();
}

class _MantenimientoListScreenState extends State<MantenimientoListScreen> {
  late Future<List<Mantenimiento>> _auxiliarElements;
  String _searchQuery = '';
  bool _searchActive = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _auxiliarElements = _getMantenimientoProvider(context).getMantenimiento();
    });
  }

  MantenimientoProvider _getMantenimientoProvider(BuildContext context) {
    return Provider.of<MantenimientoProvider>(context, listen: false);
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      _auxiliarElements = _getMantenimientoProvider(context)
          .getMantenimiento()
          .then((mantenimiento) {
        if (_searchQuery.isEmpty) {
          return mantenimiento;
        } else {
          return mantenimiento.where((element) {
            return element.id
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();
        }
      });
    });
  }

  void _filterByOficio(String oficio) {
    setState(() {
      _auxiliarElements = _getMantenimientoProvider(context)
          .getMantenimiento()
          .then((mantenimiento) {
        return mantenimiento.where((element) {
          return element.oficio == oficio &&
              (element.nombreCompleto
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Mantenimientos'),
        ),
        drawer: DrawerMenuMantenimiento(
          onOficioSelected: (oficio) {
            _filterByOficio(oficio);
          },
        ),
        body: Column(
          children: [
            searchArea(),
            listItemsArea(),
          ],
        ),
      ),
    );
  }

  Expanded listItemsArea() {
    return Expanded(
        child: FutureBuilder<List<Mantenimiento>>(
            future: _auxiliarElements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No hay gente de mantenimiento disponible'));
              } else {
                final mantenimiento = snapshot.data!;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: mantenimiento.length,
                  itemBuilder: (BuildContext context, int index) {
                    final element = mantenimiento[index];
                    final avatar = 'assets/avatars/avatar$index.png';

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'perfil_experto_item',
                          arguments: <String, dynamic>{
                            'avatar': avatar,
                            'name': element.nombreCompleto,
                            'fecha_nacimiento': element.fechaNac.split('T')[0],
                            'disponibilidad': element.disponibilidad,
                            'precio': element.precio,
                            'calificacion': element.calificacion,
                            'id': element.id,
                            'sexo': element.sexo
                          },
                        );
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onLongPress: () {
                        log('onLongPress $index');
                        _showRatingPopup(context, index, mantenimiento);
                      },
                      child: Container(
                        height: 110,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(31, 22, 78, 189),
                              blurRadius: 15,
                              spreadRadius: 5,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                avatar,
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
                                    element.nombreCompleto,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('Precio: ${element.precio}'),
                                  Text('Oficio: ${element.oficio}'),
                                ],
                              ),
                            ),
                            Icon(
                              element.disponibilidad
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: element.disponibilidad
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text('${element.calificacion}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));
  }

  AnimatedSwitcher searchArea() {
    return AnimatedSwitcher(
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
                      onChanged: (value) => _updateSearch(value),
                      onFieldSubmitted: (value) => _updateSearch(value),
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
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_arrow_left_outlined),
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
    );
  }

  void _showRatingPopup(
      BuildContext context, int index, List<Mantenimiento> mantenimiento) {
    final rating = double.parse(mantenimiento[index].calificacion);
    final stars = (rating / 2).round();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 80,
          child: Column(
            children: [
              const Text('Calificación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
