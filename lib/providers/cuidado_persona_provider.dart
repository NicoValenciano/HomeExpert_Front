import 'package:flutter/material.dart';
import 'package:home_expert_front/model/list_cuidado_persona_model.dart';
import 'package:home_expert_front/model/cuidado_persona_model.dart';
import 'package:http/http.dart' as http;

class CuidadoPersonasProvider extends ChangeNotifier {
  List<CuidadoPersonas> listCuidadores = [];

  Future<List<CuidadoPersonas>> getCuidador() async {
    try {
      //https://homeexpert.onrender.com/api/v1/cuidadoPersona
      final url = Uri.https('homeexpert.onrender.com', 'api/v1/cuidadoPersona');

      //final url = Uri.https('https://66e20943c831c8811b5703f6.mockapi.io/', '/api/v1/cuidadoPersona'); >> endpoint para consumir por Mockapi
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        listCuidadores = cuidadoresPersonasFromJson(response.body);
        notifyListeners();
        return listCuidadores;
      } else {
        throw Exception('Error en la solicitud ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Ocurrio un error $err');
    }
  }
}
