class Mantenimiento {
  String nombreCompleto;
  String precio;
  String fechaNac;
  bool disponibilidad;
  String sexo;
  String calificacion;
  String id;
  String? foto;
  String oficio;

  Mantenimiento({
    required this.nombreCompleto,
    required this.precio,
    required this.fechaNac,
    required this.disponibilidad,
    required this.sexo,
    required this.calificacion,
    required this.id,
    required this.oficio,
    this.foto,
  });

  factory Mantenimiento.fromJson(Map<String, dynamic> json) {
    return Mantenimiento(
        nombreCompleto: json['nombreCompleto'],
        precio: json['precio'],
        fechaNac: json['fechaNac'],
        disponibilidad: json['disponibilidad'],
        sexo: json['sexo'],
        calificacion: json['calificacion'],
        id: json['id'],
        oficio: json['oficio'],
        foto: json['foto']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombreCompleto,
      'precio': precio,
      'fechaNacimiento': fechaNac,
      'disponibilidad': disponibilidad,
      'sexo': sexo,
      'calificacion': calificacion,
      'id': id,
      'foto': foto,
    };
  }
}
