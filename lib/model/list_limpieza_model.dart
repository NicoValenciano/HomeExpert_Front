import 'dart:convert';
import 'package:home_expert_front/model/limpieza_model.dart';

List<Limpieza> limpiezaFromJson(String str) {
  return List<Limpieza>.from(json.decode(str).map((x) => Limpieza.fromJson(x)));
}

String limpiezaToJson(List<Limpieza> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
