import 'dart:convert';
import 'package:home_expert_front/model/mantenimiento_model.dart';

List<Mantenimiento> mantenimientoFromJson(String str) {
  final jsonResponse = MantenimientoResponse.fromJson(json.decode(str));
  return jsonResponse.data;
}

String mantenimientoToJson(List<Mantenimiento> data) {
  final response = MantenimientoResponse(msg: "Ok", data: data);
  return json.encode(response);
}

List<String> obtenerOficios(List<Mantenimiento> personas) {
  // Extraer todos los oficios y eliminarlos duplicados
  return personas.map((persona) => persona.oficio).toSet().toList();
}
