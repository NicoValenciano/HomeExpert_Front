class CuidadoPersonaResponse {
  final String msg;
  final List<CuidadoPersonas> data;

  CuidadoPersonaResponse({
    required this.msg,
    required this.data,
  });

  factory CuidadoPersonaResponse.fromJson(Map<String, dynamic> json) =>
      CuidadoPersonaResponse(
        msg: json["msg"],
        data: List<CuidadoPersonas>.from(
            json["data"].map((x) => CuidadoPersonas.fromJson(x))),
      );
}

class CuidadoPersonas {
  String nombreCompleto;
  String precio;
  String fechaNacimiento;
  bool disponibilidad;
  String sexo;
  int calificacion;
  String id;
  String? foto;

  CuidadoPersonas({
    required this.nombreCompleto,
    required this.precio,
    required this.fechaNacimiento,
    required this.disponibilidad,
    required this.sexo,
    required this.calificacion,
    required this.id,
    this.foto,
  });

  factory CuidadoPersonas.fromJson(Map<String, dynamic> json) => CuidadoPersonas(
        nombreCompleto: json['nombreCompleto'],
        precio: json['precio'],
        fechaNacimiento: json['fechaNacimiento'],
        disponibilidad: json['disponibilidad'],
        sexo: json['sexo'],
        calificacion: json['calificacion'],
        id: json['id'],
        foto: json['foto'],
  );
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombreCompleto,
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
