import 'package:admin_dashboard/ui/views/comisiones_view.dart';
import 'package:admin_dashboard/ui/views/historicoMedico.dart';
import 'package:admin_dashboard/ui/views/notas_view.dart';
import 'package:admin_dashboard/ui/views/registerMedico.dart';
import 'package:admin_dashboard/ui/views/reporte_diario.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/providers/auth_provider.dart';

import 'package:admin_dashboard/ui/views/blank_view.dart';
import 'package:admin_dashboard/ui/views/dashboard_view.dart';
import 'package:admin_dashboard/ui/views/icons_view.dart';
import 'package:admin_dashboard/ui/views/login_view.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.registerPacientRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return DashboardView();
    else
      return LoginView();
  });

  static Handler icons = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.iconsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return IconsView();
    else
      return LoginView();
  });

  static Handler registerMedico = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.registerMedicoRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return RegisterMedico();
    else
      return LoginView();
  });

  static Handler historicoMedico = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.historicoMedicoRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return HistoricoMedico(0);
    else
      return LoginView();
  });

  static Handler historicoPaciente = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.historicoPacienteRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return HistoricoMedico(1);
    else
      return LoginView();
  });

  static Handler reporteDiario = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.reporteDiarioRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return ReporteDiario();
    else
      return LoginView();
  });

  static Handler comisiones = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.comisionesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return ComisionesView();
    else
      return LoginView();
  });

  static Handler notas = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.notasRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return NotasView();
    else
      return LoginView();
  });

  static Handler blank = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.blankRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return BlankView();
    else
      return LoginView();
  });
}
