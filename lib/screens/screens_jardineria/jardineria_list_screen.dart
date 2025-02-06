import 'package:flutter/material.dart';
import 'package:home_expert_front/model/jardineria_model.dart';
import 'package:home_expert_front/providers/jardineria_provider.dart';
import 'package:provider/provider.dart';

class JardineriaListScreen extends StatefulWidget {
  const JardineriaListScreen({super.key});

  @override
  State<JardineriaListScreen> createState() => _JardineriaListScreenState();
}

class _JardineriaListScreenState extends State<JardineriaListScreen> {
  late Future<List<Jardineria>> _auxiliarElements;
  List<Jardineria> _currentElements = [];
  String _searchQuery = '';
  bool _searchActive = false;
  bool showAvailable = true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;

  RangeValues _currentRangeValues = const RangeValues(0, 100000);
  final double _minPrice = 0;
  final double _maxPrice = 100000;

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
      _auxiliarElements = _getJardineriaProvider(context).getJardineria();
      _auxiliarElements.then((elements) {
        _currentElements = elements;
        // Update range values based on actual data
        double maxPrice = elements
            .map((e) => e.precio.toDouble())
            .reduce((a, b) => a > b ? a : b);
        _currentRangeValues = RangeValues(_minPrice, maxPrice);
      });
    });
  }

  JardineriaProvider _getJardineriaProvider(BuildContext context) {
    return Provider.of<JardineriaProvider>(context, listen: false);
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      if (_searchQuery.isEmpty) {
        _auxiliarElements = _getJardineriaProvider(context).getJardineria();
      } else {
        _auxiliarElements = _getJardineriaProvider(context)
            .getJardineria()
            .then((jardineros) => jardineros
                .where((jardinero) => jardinero.id
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList());
      }
    });
  }

  void _filterAvailable(bool available) {
    setState(() {
      showAvailable = available;
      _auxiliarElements = _getJardineriaProvider(context).getJardineria().then(
          (jardineros) => jardineros
              .where((jardinero) => jardinero.disponibilidad == available)
              .toList());
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _filterAvailable(true);
      } else if (_selectedIndex == 1) {
        _filterAvailable(false);
      } else {
        _loadData();
      }
    });
  }

  void _filterByPriceRange() {
    setState(() {
      _auxiliarElements =
          _getJardineriaProvider(context).getJardineria().then((jardineros) {
        return jardineros.where((jardinero) {
          double price = double.parse(jardinero.precio.toString());
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
            rangeFilterArea(),
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
      child: FutureBuilder<List<Jardineria>>(
        future: _auxiliarElements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay jardineros disponibles'));
          }

          final jardineros = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: jardineros.length,
            itemBuilder: (BuildContext context, int index) {
              final jardinero = jardineros[index];
              final avatar = 'assets/avatars/avatar$index.png';

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'perfil_experto_item',
                    arguments: <String, dynamic>{
                      'precio': jardinero.precio,
                      'name': jardinero.name,
                      'sexo': jardinero.sexo,
                      'avatar': avatar,
                      'disponibilidad': jardinero.disponibilidad,
                      'calificacion': jardinero.calificacion ~/ 10000,
                      'fecha_nacimiento':
                          jardinero.fechaNacimiento.split('T')[0]
                    },
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onLongPress: () {
                  _showRatingPopup(context, jardinero.calificacion);
                },
                child: Container(
                  height: 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            Text(jardinero.id),
                            Text(
                              jardinero.name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text('Precio: \$${jardinero.precio}'),
                          ],
                        ),
                      ),
                      Icon(
                        jardinero.disponibilidad
                            ? Icons.verified
                            : Icons.error_outline,
                        color: jardinero.disponibilidad
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text('${jardinero.calificacion}'),
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
                      decoration:
                          const InputDecoration(hintText: 'Buscar por ID'),
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

  void _showRatingPopup(BuildContext context, int rating) {
    final stars = ((rating ~/ 10000) / 2).round();

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

  Container rangeFilterArea() {
    return Container(
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
              '\$${_currentRangeValues.start.round()}',
              '\$${_currentRangeValues.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                _auxiliarElements = Future.value(_currentElements
                    .where((jardinero) =>
                        jardinero.precio >= values.start &&
                        jardinero.precio <= values.end)
                    .toList());
              });
            },
          ),
        ],
      ),
    );
  }
}
