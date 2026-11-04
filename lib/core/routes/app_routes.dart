import 'package:flutter/material.dart';

import '../../views/screens/login_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/comprobante_screen.dart';

/// Las tres pantallas del flujo: acceso, formulario y comprobante.
class AppRoutes {
  AppRoutes._();

  static const login = '/';
  static const home = '/home';
  static const comprobante = '/comprobante';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(),
    comprobante: (_) => const ComprobanteScreen(),
  };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
      settings: settings,
    );
  }
}
