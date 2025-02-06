import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/limpieza_model.dart';
import '../model/list_limpieza_model.dart';

class LimpiezaProvider extends ChangeNotifier {
  List<Limpieza> listLimpieza = [];

  Future<List<Limpieza>> getLimpieza() async {
    try {
      final url = Uri.https(
          '66e20a67c831c8811b5706cb.mockapi.io', 'api/v1/limpiezaDelHogar');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        listLimpieza = limpiezaFromJson(response.body);
        notifyListeners();
        return listLimpieza;
      } else if (response.statusCode == 404) {
        throw Exception('No se encontraron servicios de limpieza.');
      } else {
        throw Exception('Ha ocurrido un error. Intenta más tarde.');
      }
    } catch (err) {
      throw Exception('Error al obtener los datos. Verifica tu conexión.');
    }
  }
}
