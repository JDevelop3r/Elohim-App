import 'dart:convert';

class Comision {
  final String nombre;
  final double valor;

  Comision(this.nombre, this.valor);

  factory Comision.fromJson(Map<String, dynamic> json) {
    return Comision(json['name'], json['valor']);
  }

  String toJson() {
    return jsonEncode({
      'nombre': nombre,
      'valor': valor,
    });
  }

  String toString() {
    final pal = nombre.split('_');
    return pal.length > 1 ? pal.reduce((value, element) => "${value[0].toUpperCase()}${value.substring(1)} ${element[0].toUpperCase()}${element.substring(1)}") : "${pal[0][0].toUpperCase()}${pal[0].substring(1)}" ;
  }
}
