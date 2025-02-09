import 'package:flutter/material.dart';
import 'package:home_expert_front/model/list_mantenimiento_model.dart';
import 'package:home_expert_front/model/mantenimiento_model.dart';
import 'package:http/http.dart' as http;

class MantenimientoProvider extends ChangeNotifier {
  List<Mantenimiento> listMantenimiento = [];

  Future<List<Mantenimiento>> getMantenimiento() async {
    try {
      final url = Uri.https('homeexpert.onrender.com', 'api/v1/mantenimiento');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        listMantenimiento = mantenimientoFromJson(response.body);
        notifyListeners();
        return listMantenimiento;
      } else {
        throw Exception('ocurrio un error: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('error: $err');
    }
  }
}
