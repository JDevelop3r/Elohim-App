import 'dart:convert';

import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AuthStatus { checking, authenticated, notAuthenticated }

const BASE_URL =
    "https://api-elohim.herokuapp.com" /* "http://localhost:3000" */;

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    this.isAuthenticated();
  }

  signUp(String nombre, String email, String password) async {
    nombre = nombre.trim();
    email = email.trim();

    var url = Uri.parse("$BASE_URL/auth/signup");

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "username": nombre,
          "email": email,
          "password": password,
          "roles": ["admin", "moderator"]
        }));

    var resBody = jsonDecode(response.body);

    if (resBody['token'] == null) {
      NotificationsService.showSnackbarError('Error. Verifica los datos');
      return;
    }

    this._token = resBody['token'];

    LocalStorage.prefs.setString('token', this._token!);
    authStatus = AuthStatus.authenticated;
    NotificationsService.showSnackbar('Sesión iniciada');
    notifyListeners();

    NavigationService.replaceTo(Flurorouter.registerPacientRoute);
  }

  login(String email, String password) async {
    email = email.trim();

    var url = Uri.parse("$BASE_URL/auth/signin");

    var response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "email": email,
              "password": password,
            }))
        .catchError((error) {
      print(error);
    });

    var resBody = jsonDecode(response.body);

    if (resBody['token'] == null) {
      NotificationsService.showSnackbarError('Email / Password incorrecto');
      return;
    }

    this._token = resBody['token'];
    LocalStorage.prefs.setString('token', this._token!);

    authStatus = AuthStatus.authenticated;
    NotificationsService.showSnackbar('Sesión iniciada');
    notifyListeners();

    NavigationService.replaceTo(Flurorouter.registerPacientRoute);
  }

  logOut() {
    LocalStorage.prefs.remove('token');

    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();

    NotificationsService.showSnackbar('Debes iniciar sesión');
    NavigationService.replaceTo(Flurorouter.registerPacientRoute);
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');

    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    // TODO: ir al backend y comprobar si el JWT es válido

    await Future.delayed(Duration(milliseconds: 1000));
    authStatus = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }
}
