import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/detail_screen.dart';

class SearchDemo extends SearchDelegate {
  final List elements;
  String searchType =
      ''; // Usaremos esto para determinar si es búsqueda por id o por profesión

  SearchDemo(this.elements);

  @override
  String? get searchFieldLabel => 'Buscar...';

  @override
  TextStyle get searchFieldStyle =>
      TextStyle(color: Colors.black); // Aseguramos que el texto sea negro

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Mostrar las opciones de búsqueda si no se ha seleccionado un tipo
    if (searchType == '') {
      return Column(
        children: [
          ListTile(
            title: Text('Buscar por ID'),
            onTap: () {
              searchType = 'id';
              showSuggestions(
                  context); // Recargar la pantalla con la búsqueda por ID
            },
          ),
          ListTile(
            title: Text('Buscar por Profesión'),
            onTap: () {
              searchType = 'profesion';
              showSuggestions(
                  context); // Recargar la pantalla con la búsqueda por Profesión
            },
          ),
        ],
      );
    }

    // Filtrar según la opción seleccionada
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query); // Filtrar por ID
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession
            .contains(query.toLowerCase()); // Filtrar por profesión
      }).toList();
    } else {
      filteredElements = elements;
    }

    // Si no se encuentran elementos que coincidan
    if (filteredElements.isEmpty) {
      return Center(
          child: Text('No se encontró ningún elemento para "$query".'));
    }

    // Mostrar los resultados
    return Column(
      children: [
        Chip(
          label: Text(searchType == 'id'
              ? 'Búsqueda por ID'
              : 'Búsqueda por Profesión'),
          backgroundColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.white),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredElements.length,
            itemBuilder: (context, index) {
              final element = filteredElements[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/avatars/${element[0]}.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(element[1]), // Nombre
                subtitle: Text(element[2]), // Profesión
                onTap: () {
                  // Navegar a la pantalla de detalles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(data: element),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mostrar los resultados de la búsqueda
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query); // Filtrar por ID
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession
            .contains(query.toLowerCase()); // Filtrar por profesión
      }).toList();
    } else {
      filteredElements = elements;
    }

    if (filteredElements.isEmpty) {
      return Center(child: Text('No se encontró ningún resultado.'));
    }

    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]), // Nombre
          subtitle: Text(element[2]), // Profesión
          trailing: Text('${element[3]} años'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(data: element),
              ),
            );
          },
        );
      },
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/detail_screen.dart';

class SearchDemo extends SearchDelegate {
  final List elements;
  String searchType =
      ''; // Usaremos esto para determinar si es búsqueda por id o por profesión

  SearchDemo(this.elements);

  @override
  String? get searchFieldLabel => 'Buscar...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Mostrar las opciones de búsqueda
    if (searchType == '') {
      return Column(
        children: [
          ListTile(
            title: Text('Buscar por ID'),
            onTap: () {
              searchType = 'id';
              showSuggestions(
                  context); // Recargar la pantalla de sugerencias con la búsqueda por ID
            },
          ),
          ListTile(
            title: Text('Buscar por Profesión'),
            onTap: () {
              searchType = 'profesion';
              showSuggestions(
                  context); // Recargar la pantalla de sugerencias con la búsqueda por profesión
            },
          ),
        ],
      );
    }

    // Filtrar según la opción seleccionada
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query);
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession.contains(query.toLowerCase());
      }).toList();
    } else {
      filteredElements = elements;
    }

    // Si no hay elementos que coincidan
    if (filteredElements.isEmpty) {
      return Center(
          child: Text('No se encontró ningún elemento para "$query".'));
    }

    // Mostrar los resultados de búsqueda
    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]),
          subtitle: Text(element[2]),
          onTap: () {
            // Navegar a la pantalla de detalles
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(data: element),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mostrar los resultados de la búsqueda
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query);
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession.contains(query.toLowerCase());
      }).toList();
    } else {
      filteredElements = elements;
    }

    if (filteredElements.isEmpty) {
      return Center(child: Text('No se encontró ningún resultado.'));
    }

    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]),
          subtitle: Text(element[2]),
          trailing: Text('${element[3]} años'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(data: element),
              ),
            );
          },
        );
      },
    );
  }
}
*/

/*class SearchDemo extends SearchDelegate {
  final List elements;
  String searchType =
      ''; // Usaremos esto para determinar si es búsqueda por id o por profesión

  SearchDemo(this.elements);

  @override
  String? get searchFieldLabel => 'Buscar...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Mostrar las opciones de búsqueda
    if (searchType == '') {
      return Column(
        children: [
          ListTile(
            title: Text('Buscar por ID'),
            onTap: () {
              searchType = 'id';
              showSuggestions(
                  context); // Recargar la pantalla de sugerencias con la búsqueda por ID
            },
          ),
          ListTile(
            title: Text('Buscar por Profesión'),
            onTap: () {
              searchType = 'profesion';
              showSuggestions(
                  context); // Recargar la pantalla de sugerencias con la búsqueda por profesión
            },
          ),
        ],
      );
    }

    // Filtrar según la opción seleccionada
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query);
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession.contains(query.toLowerCase());
      }).toList();
    } else {
      filteredElements = elements;
    }

    // Si no hay elementos que coincidan
    if (filteredElements.isEmpty) {
      return Center(
          child: Text('No se encontró ningún elemento para "$query".'));
    }

    // Mostrar los resultados de búsqueda
    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        final id = elements.indexOf(element);
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]),
          subtitle: Text(element[2]),
          onTap: () {
            // Navegar a la pantalla de detalles
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(data: element),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mostrar los resultados de la búsqueda
    List filteredElements;
    if (searchType == 'id') {
      filteredElements = elements.where((element) {
        final id = elements.indexOf(element).toString();
        return id.contains(query);
      }).toList();
    } else if (searchType == 'profesion') {
      filteredElements = elements.where((element) {
        final profession = element[2].toString().toLowerCase();
        return profession.contains(query.toLowerCase());
      }).toList();
    } else {
      filteredElements = elements;
    }

    if (filteredElements.isEmpty) {
      return Center(child: Text('No se encontró ningún resultado.'));
    }

    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]),
          subtitle: Text(element[2]),
          trailing: Text('${element[3]} años'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(data: element),
              ),
            );
          },
        );
      },
    );
  }
}

*/

/*import 'package:flutter/material.dart';

class SearchDemo extends SearchDelegate {
  final List elements;

  SearchDemo(this.elements);

  @override
  String? get searchFieldLabel => 'Buscar por ID...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredElements = query.isEmpty
        ? elements
        : elements.where((element) {
            // Si el id es el índice
            final id = elements.indexOf(element).toString();
            return id.contains(query);
          }).toList();

    return ListView.builder(
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        final element = filteredElements[index];
        final id = elements.indexOf(element);
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/${element[0]}.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(element[1]),
          subtitle: Text(element[2]),
          onTap: () {
            query = id.toString();
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredElements = elements.where((element) {
      final id = elements.indexOf(element).toString();
      return id == query;
    }).toList();

    if (filteredElements.isEmpty) {
      return Center(
        child: Text('No se encontró ningún elemento con ID $query'),
      );
    }

    final element = filteredElements.first;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/avatars/${element[0]}.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(element[1]),
      subtitle: Text(element[2]),
      trailing: Text('${element[3]} años'),
    );
  }
}
*/