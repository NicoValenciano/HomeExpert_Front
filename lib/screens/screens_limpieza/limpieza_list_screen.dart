import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/detail_screen.dart';
import 'dart:developer';
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

  // Filtro por rango de precios
  RangeValues _currentRangeValues = const RangeValues(0, 5000);
  final double _minPrice = 0;
  final double _maxPrice = 5000;

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
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _auxiliarElements = listadoLimpieza.where((element) {
        // Filtrar por nombre (si se especifica)
        bool matchesSearchQuery = element['nombreCompleto']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());

        // Filtrar por precio
        double price = double.parse(element['precio'].toString());
        bool matchesPriceRange = price >= _currentRangeValues.start &&
            price <= _currentRangeValues.end;

        return matchesSearchQuery && matchesPriceRange;
      }).toList();
    });
  }

  void _filterByPriceRange(RangeValues values) {
    setState(() {
      _currentRangeValues = values;
      _applyFilters();
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
            priceRangeArea(),
            listItemsArea(),
          ],
        ),
      ),
    );
  }

  // Área del filtro de precio
  Padding priceRangeArea() {
    return Padding(
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
              _filterByPriceRange(values);
            },
          ),
        ],
      ),
    );
  }

  Expanded listItemsArea() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElements.length,
        itemBuilder: (BuildContext context, int index) {
          final element = _auxiliarElements[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(data: element),
                ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element['nombreCompleto'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          '\$${element['precio']}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Área de búsqueda
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
                    icon: const Icon(Icons.keyboard_arrow_left_outlined),
                  ),
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
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
    );
  }
}
