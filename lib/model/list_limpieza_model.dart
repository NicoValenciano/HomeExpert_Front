import 'dart:convert';
import 'package:home_expert_front/model/limpieza_model.dart';

List<Limpieza> limpiezaFromJson(String str) {
  final jsonResponse = LimpiezaResponse.fromJson(json.decode(str));
  return jsonResponse.data;
}

String limpiezaToJson(List<Limpieza> data) {
  final response = LimpiezaResponse(msg: "Ok", data: data);
  return json.encode(response);
}
