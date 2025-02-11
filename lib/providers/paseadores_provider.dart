import 'package:flutter/material.dart';
import 'package:home_expert_front/model/paseadores_model.dart';
import 'package:http/http.dart' as http;

import '../model/list_paseadores_model.dart';

class PaseadoresProvider extends ChangeNotifier {
  List<Paseadores> listPaseadores = [];

  Future<List<Paseadores>> getPaseadores() async {
    try {
      final url = Uri.https('homeexpert.onrender.com', 'api/v1/paseador');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

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
