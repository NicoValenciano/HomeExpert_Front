import 'package:flutter/material.dart';
import 'package:flutter_application_base/screens/detail_screen.dart';
import '../../mocks/mantenimiento_mock.dart' show elements;
import 'drawer_menu_mantenimiento.dart';

class MantenimientoListScreen extends StatefulWidget {
  const MantenimientoListScreen({super.key});

  @override
  State<MantenimientoListScreen> createState() =>
      _MantenimientoListScreenState();
}

class _MantenimientoListScreenState extends State<MantenimientoListScreen> {
  List<Map<String, dynamic>> _auxiliarElements = [];
  String _searchQuery = '';
  bool _searchActive = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _auxiliarElements = elements;
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

  void _filterByOficio(String oficio) {
    setState(() {
      _auxiliarElements = elements.where((element) {
        return element['oficio'] == oficio &&
            (element['nombreCompleto']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()));
      }).toList();
    });
  }

  void _applyFilters() {
    setState(() {
      _auxiliarElements = elements.where((element) {
        return element['nombreCompleto']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
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
                  builder: (context) => DetailScreen(
                    data: {
                      'precio': element['precio'],
                      'nombreCompleto': element['nombreCompleto'],
                      'sexo': element['sexo'],
                      'foto': element['foto'],
                      'disponibilidad': element['disponibilidad'],
                      'calificacion': element['calificacion'],
                      'oficio': element['oficio'],
                    },
                  ),
                ),
              );
            },
            child: Container(
              height: 110,
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
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/m_avatars/${element['foto']}.png',
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
                          element['nombreCompleto'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text('Precio: ${element['precio']}'),
                        Text('Oficio: ${element['oficio']}'),
                      ],
                    ),
                  ),
                  Icon(
                    element['disponibilidad']
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        element['disponibilidad'] ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text('${element['calificacion']}'),
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
}
