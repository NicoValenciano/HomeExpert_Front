class LimpiezaResponse {
  final String msg;
  final List<Limpieza> data;

  LimpiezaResponse({
    required this.msg,
    required this.data,
  });

  factory LimpiezaResponse.fromJson(Map<String, dynamic> json) =>
      LimpiezaResponse(
        msg: json["msg"],
        data:
            List<Limpieza>.from(json["data"].map((x) => Limpieza.fromJson(x))),
      );
}

class Limpieza {
  String nombre;
  String? foto;
  String fechaNacimiento;
  String sexo;
  bool disponible;
  String precio;
  int calificacion;
  String id;

  Limpieza({
    required this.nombre,
    this.foto,
    required this.fechaNacimiento,
    required this.sexo,
    required this.disponible,
    required this.precio,
    required this.calificacion,
    required this.id,
  });

  factory Limpieza.fromJson(Map<String, dynamic> json) => Limpieza(
        nombre: json["nombre"],
        foto: json["foto"],
        fechaNacimiento: json["fechaNacimiento"],
        sexo: json["sexo"],
        disponible: json["disponible"],
        precio: json["precio"],
        calificacion: json["calificacion"],
        id: json["id"],
      );
}

enum Sexo {
  female,
  male,
}

final sexoValues = EnumValues({"female": Sexo.female, "male": Sexo.male});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
