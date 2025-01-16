import 'package:flutter/material.dart';
import 'package:home_expert_front/model/list_paseadores_model.dart';
import 'package:home_expert_front/model/paseadores_model.dart';
import 'package:http/http.dart' as http;

class PaseadoresProvider extends ChangeNotifier {

  List<Paseadores> listPaseadores = [];

  Future<List<Paseadores>> getPaseadores() async {

    try {
      final url =
          Uri.https('66e209c3c831c8811b570593.mockapi.io', 'api/v1/paseador');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        listPaseadores = paseadoresFromJson(response.body);
        notifyListeners();
        return listPaseadores;
      } else {
        throw Exception('Error en la solicitud ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Ocurrio un error $err');
    }
  }

}