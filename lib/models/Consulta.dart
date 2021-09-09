import 'dart:convert';

import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/models/Pacient.dart';

const FORMA_PAGO = {
  "efectivo\$": 'Efectivo \$',
  "debito": 'Punto Débito',
  "zelle\$": 'Zelle',
  "transferencia": 'Transferencia',
  "pago_movil": 'Pago Movil',
  "efectivoBss": 'Efectivo Bs',
  "credito": 'Punto Crédito',
  "otro": 'Otro',
};

class Consulta {
  late Doctor _doctor;
  late Pacient _paciente;
  late int _doctorCed;
  late int _pacCed;
  late DateTime _fecha;
  late String _area;
  late String _trabajo;
  late String _observaciones;
  List<dynamic> _pago = [];

  Consulta();

  factory Consulta.fromJson(Map<String, dynamic> json) {
    Consulta res = Consulta();
    final doctor = Doctor.fromJson(json['doctor']);
    print(json['doctor']);
    final paciente = Pacient.fromJson(json['pacient']);
    res._doctor = doctor;
    res._paciente = paciente;
    res.fecha = DateTime.parse(json['date']);
    res.area = json['area']['name'];
    res.trabajo = json['trabajo'];
    res.observaciones = json['observaciones'];
    res._pago = json['pago'];
    return res;
  }

  set doctorCed(value) => _doctorCed = value;
  int get doctorCed => _doctorCed;

  set fecha(value) => _fecha = value;
  DateTime get fecha => _fecha;

  set pacCed(value) => _pacCed = value;
  int get pacCed => _pacCed;

  set area(value) => _area = value;
  String get area => _area;

  set trabajo(value) => _trabajo = value;
  String get trabajo => _trabajo;

  set observaciones(value) => _observaciones = value;
  String get observaciones => _observaciones;

  Pacient get paciente => _paciente;

  Doctor get doctor => _doctor;

  set agregarPago(Map<String, dynamic> value) => _pago.add(value);
  List<dynamic> get pago => _pago;

  toJson() {
    return jsonEncode({
      'doctor': doctorCed,
      'pacient': pacCed,
      'area': area,
      'trabajo': trabajo,
      'observaciones': observaciones,
      'pago': pago
    });
  }
}
