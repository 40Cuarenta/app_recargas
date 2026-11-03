import 'package:flutter/material.dart';
import '../../views/screens/comprobante_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/login_screen.dart';
import '../../views/screens/nueva_recarga_screen.dart';
import '../../views/screens/numero_recarga_screen.dart';
import '../../views/screens/operadoras_screen.dart';
import '../../views/screens/pago_exitoso_screen.dart';

/// Centralización de rutas nombradas y generador de navegación de la aplicación.
/// Garantiza navegación desacoplada y predecible entre pantallas sin pasar datos
/// mediante argumentos sueltos, utilizando el gestor de estado central (Controllers).
class AppRoutes {
  AppRoutes._();

  // --- Constantes de Nombres de Ruta ---
  /// Pantalla de inicio de sesión
  static const String login = '/';

  /// Pantalla principal / dashboard
  static const String home = '/home';

  /// Paso 1: Ingreso de número celular a recargar
  static const String numero = '/numero-recarga';
  static const String numeroRecarga = numero;

  /// Paso 2: Selección de operadora móvil
  static const String operadoras = '/operadoras';

  /// Paso 3: Configuración de combo o valor monetario
  static const String nuevaRecarga = '/nueva-recarga';

  /// Paso 4: Comprobante y pre-liquidación con método de pago
  static const String comprobante = '/comprobante';

  /// Paso 5: Confirmación de pago exitoso con animación y recibo
  static const String pagoExitoso = '/pago-exitoso';

  /// Mapa de rutas nombradas estándar de Flutter.
  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        numero: (context) => const NumeroRecargaScreen(),
        operadoras: (context) => const OperadorasScreen(),
        nuevaRecarga: (context) => const NuevaRecargaScreen(),
        comprobante: (context) => const ComprobanteScreen(),
        pagoExitoso: (context) => const PagoExitosoScreen(),
      };

  /// Generador dinámico de rutas siguiendo el patrón del proyecto guía.
  /// Provee control fino de rutas y fallback en caso de rutas inexistentes.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    // Ruta de respaldo por defecto
    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
      settings: settings,
    );
  }

  /// Ruta de respaldo en caso de que una ruta no esté registrada.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
      settings: settings,
    );
  }
}

