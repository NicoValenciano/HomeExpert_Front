import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:home_expert_front/model/cuidadoPersona_model.dart';
import 'package:home_expert_front/providers/cuidadoPersona_provider.dart';
import 'package:provider/provider.dart';

class CuidadoresListScreen extends StatefulWidget {
  const CuidadoresListScreen({super.key});

  @override
  State<CuidadoresListScreen> createState() => _CuidadoresListScreenState();
}

class _CuidadoresListScreenState extends State<CuidadoresListScreen> {
  late Future<List<CuidadoPersonas>> _auxiliarElements;
  String _searchQuery = '';
  bool _searchActive = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  RangeValues _currentRangeValues = const RangeValues(0, 1000);
  final double _minPrice = 0;
  final double _maxPrice = 1000;

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
      _auxiliarElements = _getCuidadorProvider(context).getCuidador();
    });
  }
  
  CuidadoPersonasProvider _getCuidadorProvider(BuildContext context) {
    return Provider.of<CuidadoPersonasProvider>(context, listen: false);
  }

  void _updateSearch(String? query) {
  setState(() {
    _searchQuery = query ?? '';
    if (_searchQuery.isEmpty) {
      _auxiliarElements = _getCuidadorProvider(context).getCuidador();
    } else {
      _auxiliarElements = _getCuidadorProvider(context)
          .getCuidador()
          .then((cuidadores) => cuidadores.where((c) {
                return c.id.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList());
    }
  });
}


  void _filterByPriceRange() {
  setState(() {
    _auxiliarElements = _getCuidadorProvider(context).getCuidador().then((cuidadores) {
      return cuidadores.where((c) {
        double price = double.tryParse(c.precio.toString()) ?? 0.0;
        return price >= _currentRangeValues.start &&
            price <= _currentRangeValues.end;
      }).toList();
    });
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_currentRangeValues.start.round()}'),
                      Text('\$${_currentRangeValues.end.round()}'),
                    ],
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: 100,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                        _filterByPriceRange();
                      });
                    },
                  ),
                ],
              ),
            ),
            listItemsArea(),
          ],
        ),
      ),
    );
  }

  Expanded listItemsArea() {
  return Expanded(
    child: FutureBuilder<List<CuidadoPersonas>>(
      future: _auxiliarElements,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay cuidadores disponibles.'));
        }

        final cuidadores = snapshot.data!;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: cuidadores.length,
          itemBuilder: (BuildContext context, int index) {
            final element = cuidadores[index];
            final avatar = 'assets/avatars/avatar$index.png';

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'perfil_experto_item',
                  arguments: <String, dynamic>{
                    'avatar': avatar,
                    'name': element.nombreCompleto,
                    'fecha_nacimiento': element.fechaNacimiento.split('T')[0],
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
                        'assets/avatars/avatar$index.png',
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
                            element.id,
                          ),
                          Text(
                            element.nombreCompleto,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text('Precio: \$${element.precio}'),
                        ],
                      ),
                    ),
                    Icon(
                      element.disponibilidad
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          element.disponibilidad ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text('${element.calificacion}'),
                  ],
                ),
              ),
            );
          },
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
