import 'dart:convert';

class Pacient {
  late String _id;
  late String _firstName;
  late String _lastName;
  late int _ced;
  late String _email;
  late int _phone;

  set firstName(value) => _firstName = value;
  get firstName => _firstName;

  set lastName(value) => _lastName = value;
  get lastName => _lastName;

  set ced(value) => _ced = value;
  get ced => _ced;

  set email(value) => _email = value;
  get email => _email;

  set phone(value) => _phone = value;
  get phone => _phone;

  get id => _id;

  Pacient();

  factory Pacient.fromJson(Map<String, dynamic> json) {
    Pacient res = Pacient();
    res.ced = json['ced'];
    res._id = json['_id'];
    res.firstName = json['firstName'];
    res.lastName = json['lastName'];
    res.email = json['email'];
    res.phone = json['phone'];
    return res;
  }

  String toJson() {
    return jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'ced': ced,
      'email': email,
      'phone': phone
    });
  }
}
