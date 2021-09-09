import 'dart:convert';

class Nota {
  String _id;
  final String contenido;
  final DateTime fecha;

  Nota(this.contenido, this.fecha, [this._id = '']);

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(json['contenido'], DateTime.parse(json['fecha']), json['_id']);
  }

  String toJson() {
    return jsonEncode({
      'contenido': contenido,
    });
  }
}
