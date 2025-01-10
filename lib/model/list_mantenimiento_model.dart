import 'dart:convert';
import 'package:home_expert_front/model/mantenimiento_model.dart';

List<Mantenimiento> mantenimientoFromJson(String str) {
  return List<Mantenimiento>.from(
      jsonDecode(str).map((x) => Mantenimiento.fromJson(x)));
}

String mantenimientoToJson(List<Mantenimiento> data) {
  return jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
}

List<String> obtenerOficios(List<Mantenimiento> personas) {
  // Extraer todos los oficios y eliminarlos duplicados
  return personas.map((persona) => persona.oficio).toSet().toList();
}
