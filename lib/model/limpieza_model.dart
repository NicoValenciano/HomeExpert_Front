class Limpieza {
  String nombre;
  String apellido;
  String foto;
  int edad;
  Sexo sexo;
  bool disponible;
  String precio;
  int calificacion;
  String id;

  Limpieza({
    required this.nombre,
    required this.apellido,
    required this.foto,
    required this.edad,
    required this.sexo,
    required this.disponible,
    required this.precio,
    required this.calificacion,
    required this.id,
  });

  factory Limpieza.fromJson(Map<String, dynamic> json) => Limpieza(
        nombre: json["nombre"],
        apellido: json["apellido"],
        foto: json["foto"],
        edad: json["edad"],
        sexo: sexoValues.map[json["sexo"]]!,
        disponible: json["disponible"],
        precio: json["precio"],
        calificacion: json["calificacion"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido": apellido,
        "foto": foto,
        "edad": edad,
        "sexo": sexoValues.reverse[sexo],
        "disponible": disponible,
        "precio": precio,
        "calificacion": calificacion,
        "id": id,
      };
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
