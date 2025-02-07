class JardineriaResponse {
  final String msg;
  final List<Jardineria> data;

  JardineriaResponse({
    required this.msg,
    required this.data,
  });

  factory JardineriaResponse.fromJson(Map<String, dynamic> json) =>
      JardineriaResponse(
        msg: json["msg"],
        data: List<Jardineria>.from(
            json["data"].map((x) => Jardineria.fromJson(x))),
      );
}

class Jardineria {
  final String name;
  final String avatar;
  final String servicio;
  final String fechaNacimiento;
  final bool disponibilidad;
  final int precio;
  final int calificacion;
  final String sexo;
  final String id;

  Jardineria({
    required this.name,
    required this.avatar,
    required this.servicio,
    required this.fechaNacimiento,
    required this.disponibilidad,
    required this.precio,
    required this.calificacion,
    required this.sexo,
    required this.id,
  });

  factory Jardineria.fromJson(Map<String, dynamic> json) => Jardineria(
        name: json["name"],
        avatar: json["avatar"],
        servicio: json["servicio"],
        fechaNacimiento: json["fechaNacimiento"],
        disponibilidad: json["disponibilidad"],
        precio: json["precio"],
        calificacion: json["calificacion"],
        sexo: json["sexo"],
        id: json["id"],
      );
}
