import 'dart:convert';

const ESPECIALIDADES = {
  "odontologia_general": 'Odontología General',
  "pediatra": 'Pediatria',
  "medicina_general": 'Medicina General',
  "medicina_familiar": 'Medicina Familiar',
  "ecografia": 'Ecografia',
  "maternidad": 'Maternidad',
  "cardiologia": 'Cardiologia',
  "ortodoncia": 'Ortodoncia',
  "cirugia_bucal": 'Cirugía Bucal',
  "ginecologia": 'Ginecología',
  "implantes": 'Implantes',
  "cirugia_maxilofacial": 'Cirugía Maxilofacial',
};

class Doctor {
  late String _id;
  late String _firstName;
  late String _lastName;
  late String _domicilioFiscal;
  late String _rif;
  late int _ced;
  late String _email;
  late int _phone;
  late List<String> _especialidades;
  late int _ganancia;

  set firstName(value) => _firstName = value;
  get firstName => _firstName;

  set domicilioFiscal(value) => _domicilioFiscal = value;
  String get domicilioFiscal => _domicilioFiscal;

  set lastName(value) => _lastName = value;
  get lastName => _lastName;

  set rif(value) => _rif = value;
  String get rif => _rif;

  set ced(value) => _ced = value;
  get ced => _ced;

  set email(value) => _email = value;
  get email => _email;

  set phone(value) => _phone = value;
  get phone => _phone;

  set especialidades(value) => _especialidades = value;
  List<String> get especialidades => _especialidades;

  set ganancia(value) => _ganancia = value;
  get ganancia => _ganancia;

  get id => _id;

  Doctor();

  factory Doctor.fromJson(Map<String, dynamic> json) {
    Doctor res = Doctor();
    res.ced = json['ced'];
    res._id = json['_id'];
    res.firstName = json['firstName'];
    res.lastName = json['lastName'];
    res.email = json['email'];
    res.ganancia = json['ganancia'];
    res.rif = json['rif'];
    res.phone = json['phone'];
    res.domicilioFiscal = json['domicilioFiscal'];
    res.especialidades = json['especialidades'].map<String>((especialidad) {
      return especialidad['name'] as String;
    }).toList();
    return res;
  }

  String toJson() {
    return jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'rif': rif,
      'ced': ced,
      'email': email,
      'phone': phone,
      'especialidades': especialidades,
      'ganancia': ganancia,
      'domicilioFiscal': domicilioFiscal,
    });
  }

  String especialidadToString() {
    final pal = especialidades.first.split('_');
    return pal.reduce((value, element) =>
        "${value[0].toUpperCase()}${value.substring(1)} ${element[0].toUpperCase()}${element.substring(1)}");
  }
}
