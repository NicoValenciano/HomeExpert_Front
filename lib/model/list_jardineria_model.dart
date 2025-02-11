import 'dart:convert';
import 'package:home_expert_front/model/jardineria_model.dart';

List<Jardineria> jardineriaFromJson(String str) {
  final jsonResponse = JardineriaResponse.fromJson(json.decode(str));
  return jsonResponse.data;
}

String jardineriaToJson(List<Jardineria> data) {
  final response = JardineriaResponse(msg: "Ok", data: data);
  return json.encode(response);
}
