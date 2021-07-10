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
            icon: Icons.app_registration_sharp,
            onPressed: () => navigateTo(Flurorouter.registerPacientRoute),
            isActive: sideMenuProvider.currentPage ==
                Flurorouter.registerPacientRoute,
          ),
          MenuItem(
              text: 'Historico', icon: Icons.history_edu, onPressed: () {}),
          SizedBox(height: 16),
          TextSeparator(text: 'Médicos'),
          MenuItem(
            text: 'Registro',
            icon: Icons.app_registration_sharp,
            onPressed: () => navigateTo(Flurorouter.registerMedicoRoute),
            isActive:
                sideMenuProvider.currentPage == Flurorouter.registerMedicoRoute,
          ),
          MenuItem(
              text: 'Historico',
              icon: Icons.note_add_outlined,
              onPressed: () {}),
          SizedBox(height: 16),
          TextSeparator(text: 'Reportes'),
          MenuItem(
            text: 'Registro\nDiarios',
            icon: Icons.domain_verification_rounded,
            onPressed: () => navigateTo(Flurorouter.iconsRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
          ),
          MenuItem(
              text: 'Recibo de \nIngresos y\nTransferencia',
              icon: Icons.receipt_long_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Comprobante\nde Pago\nImpuesto',
              icon: Icons.playlist_add_check_outlined,
              onPressed: () {}),
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
