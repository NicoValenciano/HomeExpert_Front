import 'dart:convert';
import 'package:home_expert_front/model/cuidado_persona_model.dart';

List<CuidadoPersonas> cuidadoresPersonasFromJson(String str) {
  final jsonResponse = CuidadoPersonaResponse.fromJson(json.decode(str));
  return jsonResponse.data;
  }

String cuidadoresPersonasToJson(List<CuidadoPersonas> data) {
  final response = CuidadoPersonaResponse(msg: "Ok", data: data);
  return json.encode(response);
}
