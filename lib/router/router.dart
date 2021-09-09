import 'package:admin_dashboard/router/dashboard_handlers.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:admin_dashboard/router/admin_handlers.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';

  // Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';

  // Dashboard
  static String registerPacientRoute = '/registerpacient';
  static String registerMedicoRoute = '/registermedico';
  static String historicoMedicoRoute = '/historicomedico';
  static String historicoPacienteRoute = '/historicopaciente';
  static String reporteDiarioRoute = '/reportediario';
  static String notasRoute = '/notas';
  static String iconsRoute = '/dashboard/icons';
  static String blankRoute = '/dashboard/blank';
  static String comisionesRoute = '/dashboard/comisiones';

  static void configureRoutes() {
    // Auth Routes
    router.define(rootRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(loginRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(registerRoute,
        handler: AdminHandlers.register, transitionType: TransitionType.none);

    // Dashboard
    router.define(registerPacientRoute,
        handler: DashboardHandlers.dashboard,
        transitionType: TransitionType.fadeIn);
    router.define(registerMedicoRoute,
        handler: DashboardHandlers.registerMedico,
        transitionType: TransitionType.fadeIn);
    router.define(historicoMedicoRoute,
        handler: DashboardHandlers.historicoMedico,
        transitionType: TransitionType.fadeIn);
    router.define(historicoPacienteRoute,
        handler: DashboardHandlers.historicoPaciente,
        transitionType: TransitionType.fadeIn);
    router.define(reporteDiarioRoute,
        handler: DashboardHandlers.reporteDiario,
        transitionType: TransitionType.fadeIn);
    router.define(comisionesRoute,
        handler: DashboardHandlers.comisiones,
        transitionType: TransitionType.fadeIn);
    router.define(notasRoute,
        handler: DashboardHandlers.notas,
        transitionType: TransitionType.fadeIn);
    router.define(iconsRoute,
        handler: DashboardHandlers.icons,
        transitionType: TransitionType.fadeIn);
    router.define(blankRoute,
        handler: DashboardHandlers.blank,
        transitionType: TransitionType.fadeIn);

    // 404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
