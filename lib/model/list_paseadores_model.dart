import 'dart:convert';

import 'package:home_expert_front/model/paseadores_model.dart';

List<Paseadores> paseadoresFromJson(String str) {
  final jsonResponse = PaseadoresResponse.fromJson(json.decode(str));
  return jsonResponse.data;
}

String paseadoresToJson(List<Paseadores> data) {
  final response = PaseadoresResponse(msg: "Ok", data: data);
  return json.encode(response);
}
