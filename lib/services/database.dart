import 'dart:convert';

import 'package:admin_dashboard/models/Comision.dart';
import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/models/Nota.dart';
import 'package:admin_dashboard/models/Pacient.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:http/http.dart' as http;

import 'notifications_service.dart';

const BASE_URL =
    /* "https://api-elohim.herokuapp.com" */ "http://localhost:3000";
class DatabaseService {
  registrarPaciente(Pacient paciente) async {
    var url = Uri.parse("$BASE_URL/pacient");
    final token = LocalStorage.prefs.getString('token');

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token ?? ''
        },
        body: paciente.toJson());

    var resBody = jsonDecode(response.body);
    print(resBody);
    NotificationsService.showSnackbarInfo(resBody['message']);
    if (resBody['error']) return false;
    return true;
  }

  registrarDoctor(Doctor doctor) async {
    var url = Uri.parse("$BASE_URL/doctor");
    final token = LocalStorage.prefs.getString('token');

    var response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-access-token': token ?? ''
            },
            body: doctor.toJson())
        .catchError((error) {
      NotificationsService.showSnackbarError('Error. Revise los datos');
      print(error);
    });

    var resBody = jsonDecode(response.body);
    print(resBody);
    NotificationsService.showSnackbarInfo(resBody['message']);
    if (resBody['error']) return false;
    return true;
  }

  registrarPago(Consulta consulta) async {
    var url = Uri.parse("$BASE_URL/consult");
    final token = LocalStorage.prefs.getString('token');

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token ?? ''
        },
        body: consulta.toJson());

    var resBody = jsonDecode(response.body);
    print(resBody);
    if (resBody['_id'] == null) {
      NotificationsService.showSnackbarError('Error. Revise los datos');
      return false;
    }
    NotificationsService.showSnackbar('Consulta Registrada.');
    return true;
  }

  Future guardarNota(Nota nota) async {
    var url = Uri.parse("$BASE_URL/notas");
    final token = LocalStorage.prefs.getString('token');

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token ?? ''
        },
        body: nota.toJson());

    var resBody = jsonDecode(response.body);
    print(resBody);
    NotificationsService.showSnackbar('Nota Registrada.');
    return true;
  }

  Future<List<Consulta>> getConsultasByDoctorCed(
      int? ced, DateTime? firstDate, DateTime? lastDate) async {
    var url = "$BASE_URL/consult";
    if (ced != null) url = 'url/doctor/$ced';
    final token = LocalStorage.prefs.getString('token');

    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'x-access-token': token ?? ''
    }).catchError((err) {
      {
        print(err);
        NotificationsService.showSnackbarError('Error con la conexión');
      }
    });

    List resBody = jsonDecode(response.body);
    return resBody.map((e) => Consulta.fromJson(e)).toList();
  }

  Future<List<Comision>> getComisiones() async {
    NotificationsService.showSnackbarInfo('Cargando...');
    final url = '$BASE_URL/comisiones';
    final response = await http.get(Uri.parse(url)).catchError((err) {
      print(err);
      NotificationsService.showSnackbarError('Error con la conexión');
    });
    List resBody = jsonDecode(response.body)['comisiones'];
    print(resBody);
    return resBody.map((e) => Comision.fromJson(e)).toList();
  }

  Future<List<Nota>> getNotas() async {
    NotificationsService.showSnackbarInfo('Cargando...');
    final url = '$BASE_URL/notas';
    final response = await http.get(Uri.parse(url)).catchError((err) {
      print(err);
      NotificationsService.showSnackbarError('Error con la conexión');
    });
    List resBody = jsonDecode(response.body)['notas'];
    print(resBody);
    return resBody.map((e) => Nota.fromJson(e)).toList();
  }

  Future updateComisiones(Comision comision) async {
    final url = '$BASE_URL/comisiones';
    final response = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: comision.toJson())
        .catchError((err) {
      print(err);
      NotificationsService.showSnackbarError('Error con la conexión');
    });
    NotificationsService.showSnackbar('Comisión actualizada');
    print(response.body);
  }

  Future<List<Consulta>> getConsultasByPacienteCed(
      int? ced, DateTime? firstDate, DateTime? lastDate) async {
    var url = "$BASE_URL/consult";
    if (ced != null) url = 'url/pacient/$ced';
    final token = LocalStorage.prefs.getString('token');

    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'x-access-token': token ?? ''
    }).catchError((err) {
      NotificationsService.showSnackbarError('Error con la conexión');
    });

    List resBody = jsonDecode(response.body);
    return resBody.map((e) => Consulta.fromJson(e)).toList();
  }
}
