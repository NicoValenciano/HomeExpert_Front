import 'package:flutter/material.dart';
import 'package:home_expert_front/model/list_cuidado_persona_model.dart';
import 'package:home_expert_front/model/cuidado_persona_model.dart';
import 'package:http/http.dart' as http;

class CuidadoPersonasProvider extends ChangeNotifier {
  List<CuidadoPersonas> listCuidadores = [];

  Future<List<CuidadoPersonas>> getCuidador() async {
    try {
      final url = Uri.https(
          '66e20943c831c8811b5703f6.mockapi.io', '/cuidadoresPersonas');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        listCuidadores = cuidadoresPersonasFromJson(response.body);
        notifyListeners();
        return listCuidadores;
      } else {
        throw Exception('ocurrio un error: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('error: $err');
    }
  }
}
