import 'package:flutter_application_base/mocks/jardineria_mock.dart'
    show elements_jardineria;
import 'package:flutter/material.dart';

class JardineriaListScreen extends StatefulWidget {
  const JardineriaListScreen({super.key});

  @override
  State<JardineriaListScreen> createState() => _JardineriaListScreenState();
}

class _JardineriaListScreenState extends State<JardineriaListScreen> {
  List _auxiliarElements = [];
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
    _auxiliarElements = elements_jardineria;
  }

  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      if (_searchQuery.isEmpty) {
        _auxiliarElements =
            elements_jardineria; // Restablecer al estado original
      } else {
        _auxiliarElements = elements_jardineria.where((element) {
          return element[1].toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterByPriceRange() {
    setState(() {
      _auxiliarElements = elements_jardineria.where((element) {
        double price = double.parse(element[5].toString());
        return price >= _currentRangeValues.start &&
            price <= _currentRangeValues.end;
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
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElements.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'custom_list_item',
                  arguments: <String, dynamic>{
                    'avatar': _auxiliarElements[index][0],
                    'name': _auxiliarElements[index][1],
                    'cargo': _auxiliarElements[index][2],
                    'stars': _auxiliarElements[index][3],
                    'favorite': _auxiliarElements[index][4],
                    'precio': _auxiliarElements[index][5],
                    'ciudad': _auxiliarElements[index][6],
                    'calificacion': _auxiliarElements[index][7]
                  });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onLongPress: () {
              _showRatingPopup(context, index);
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(31, 206, 219, 246),
                        blurRadius: 0,
                        spreadRadius: 3,
                        offset: Offset(0, 6))
                  ]),
              child: Row(
                children: [
                  Image.asset(
                      'assets/avatars/${_auxiliarElements[index][0]}.png',
                      width: 50,
                      height: 50),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _auxiliarElements[index][1],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(_auxiliarElements[index][2]),
                      ],
                    ),
                  ),
                  const Icon(Icons.attach_money, color: Colors.green),
                  Text(_auxiliarElements[index][5].toString())
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

  void _showRatingPopup(BuildContext context, int index) {
    final rating = double.parse(_auxiliarElements[index][7]); // Get rating 0-10
    final stars = (rating / 2).round(); // Convert to 5 star scale

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
