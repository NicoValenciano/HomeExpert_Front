class PaseadoresResponse {
  final String msg;
  final List<Paseadores> data;

  PaseadoresResponse({
    required this.msg,
    required this.data,
  });

  factory PaseadoresResponse.fromJson(Map<String, dynamic> json) =>
      PaseadoresResponse(
        msg: json["msg"],
        data: List<Paseadores>.from(
            json["data"].map((x) => Paseadores.fromJson(x))),
      );
}

class Paseadores {
  String nombre;
  String precio;
  String fechaNacimiento;
  bool disponibilidad;
  String sexo;
  int calificacion;
  String id;
  String? foto;

  Paseadores({
    required this.nombre,
    required this.precio,
    required this.fechaNacimiento,
    required this.disponibilidad,
    required this.sexo,
    required this.calificacion,
    required this.id,
    this.foto,
  });

  factory Paseadores.fromJson(Map<String, dynamic> json) {
    return Paseadores(
        nombre: json['nombre'],
        precio: json['precio'],
        fechaNacimiento: json['fechaNacimiento'],
        disponibilidad: json['disponibilidad'],
        sexo: json['sexo'],
        calificacion: json['calificacion'],
        id: json['id'],
        foto: json['foto']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precio': precio,
      'fechaNacimiento': fechaNacimiento,
      'disponibilidad': disponibilidad,
      'sexo': sexo,
      'calificacion': calificacion,
      'id': id,
      'foto': foto,
    };
  }
}
