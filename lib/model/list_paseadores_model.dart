import 'dart:convert';
import 'package:home_expert_front/model/paseadores_model.dart';

List<Paseadores> paseadoresFromJson(String str) {
  return List<Paseadores>.from(jsonDecode(str).map((x) => Paseadores.fromJson(x)));
}

String paseadoresToJson(List<Paseadores> data ){
  return jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
}
