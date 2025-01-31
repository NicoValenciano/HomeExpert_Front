import 'dart:convert';

import 'package:home_expert_front/model/cuidadoPersona_model.dart';

List<CuidadoPersonas> cuidadoresPersonasFromJson(String str) {
  return List<CuidadoPersonas>.from(
      jsonDecode(str).map((x) => CuidadoPersonas.fromJson(x)));
}

String cuidadoresPersonasToJson(List<CuidadoPersonas> data) {
  return jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
}
