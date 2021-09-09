import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/sidemenu_provider.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/services/navigation_service.dart';

import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/logo.dart';
import 'package:admin_dashboard/ui/shared/widgets/text_separator.dart';

class Sidebar extends StatelessWidget {
  void navigateTo(String routeName) {
    NavigationService.navigateTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 20),
          TextSeparator(text: 'Paciente'),
          MenuItem(
            text: 'Registro',
            icon: Icons.app_registration,
            onPressed: () => navigateTo(Flurorouter.registerPacientRoute),
            isActive: sideMenuProvider.currentPage ==
                Flurorouter.registerPacientRoute,
          ),
          MenuItem(
              text: 'Historico',
              icon: Icons.history_edu,
              onPressed: () => navigateTo(Flurorouter.historicoPacienteRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.historicoPacienteRoute,),
          SizedBox(height: 16),
          TextSeparator(text: 'Médicos'),
          MenuItem(
            text: 'Registro',
            icon: Icons.app_registration,
            onPressed: () => navigateTo(Flurorouter.registerMedicoRoute),
            isActive:
                sideMenuProvider.currentPage == Flurorouter.registerMedicoRoute,
          ),
          MenuItem(
              text: 'Historico',
              icon: Icons.note_add_outlined,
              onPressed: () => navigateTo(Flurorouter.historicoMedicoRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.historicoMedicoRoute,),
          SizedBox(height: 16),
          TextSeparator(text: 'Reportes'),
          MenuItem(
            text: 'Notas',
            icon: Icons.note,
            onPressed: () => navigateTo(Flurorouter.notasRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.notasRoute
          ),
          MenuItem(
            text: 'Comisiones',
            icon: Icons.monetization_on,
            onPressed: () => navigateTo(Flurorouter.comisionesRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.comisionesRoute,
          ),
          MenuItem(
            text: 'Registros\nDiarios',
            icon: Icons.domain_verification_rounded,
            onPressed: () => navigateTo(Flurorouter.reporteDiarioRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.reporteDiarioRoute,
          ),
          SizedBox(height: 16),
          TextSeparator(text: 'Salida'),
          MenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                authProvider.logOut();
              }),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xff092044),
        Color(0xff092042),
      ]),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]);
}
