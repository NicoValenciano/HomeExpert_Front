import 'package:flutter/material.dart';

class PeopleProvider extends ChangeNotifier {
  String nombre = '';
  String apellido = '';
  bool isMale = true;

  void setNombre(String newNombre) {
    nombre = newNombre;
    notifyListeners();
  }

  void setApellido(String newApellido) {
    apellido = newApellido;
    notifyListeners();
  }

  void setGender({required bool isMale}) {
    this.isMale = isMale;
    notifyListeners();
  }
}
