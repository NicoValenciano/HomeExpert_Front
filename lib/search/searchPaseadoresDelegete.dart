// import 'package:flutter/material.dart';
// import 'package:home_expert_front/providers/paseadores_provider.dart';
// import 'package:provider/provider.dart';

// import '../model/paseadores_model.dart';

// class Searchpaseadoresdelegete extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           Provider.of<PaseadoresProvider>(context, listen: false)
//               .clearActiveSearch();
//         },
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final paseadorProvider =
//         Provider.of<PaseadoresProvider>(context, listen: false);

//     if (query.isEmpty) {
//       return Container();
//     }

//     bool isSearchById = int.tryParse(query) != null;

//     Future<List<Paseadores>> searchFuture;

//     if (isSearchById) {
//       int id = int.parse(query);
//       searchFuture =
//           paseadorProvider.searchPaseadoresById(id); // Búsqueda por ID
//     } else {
//       searchFuture =
//           paseadorProvider.searchPaseadoresByQuery(query); // Búsqueda por texto
//     }

//     // El FutureBuilder se encarga de mostrar los resultados según el estado de la búsqueda
//     return FutureBuilder<List<Paseadores>>(
//       future: searchFuture, // El future que ejecutará la búsqueda
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Si estamos esperando los resultados, mostramos un indicador de carga
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           // Si ocurre un error, mostramos un mensaje
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.hasData) {
//           final paseadores = snapshot.data!;

//           if (paseadores.isEmpty) {
//             return const Center(child: Text('No se encontraron resultados'));
//           }

//           // Si hay resultados, mostramos la lista
//           return ListView.builder(
//             itemCount: paseadores.length,
//             itemBuilder: (context, index) {
//               final paseador = paseadores[index];
//               return ListTile(
//                 title: Text('${paseador.nombre} ${paseador.apellido}'),
//                 subtitle: Text(paseador.id),
//                 onTap: () {
//                   query = '${paseador.nombre} ${paseador.apellido}';
//                   showResults(
//                       context); // Mostrar los resultados cuando se hace clic en un item
//                 },
//               );
//             },
//           );
//         }

//         // Si no hay datos y no hay errores, muestra un mensaje por defecto
//         return const Center(child: Text('No hay resultados'));
//       },
//     );
//   }
// }
