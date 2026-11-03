import 'package:flutter/material.dart';
import '../data/datos_simulados.dart';
import '../models/usuario.dart';

/// Controlador de Autenticación y Sesión de Usuario (ChangeNotifier).
/// Gestiona el inicio de sesión, cierre de sesión, usuario activo y actualización de saldo.
class AuthController extends ChangeNotifier {
  Usuario? _usuarioActual;
  String? _error;
  bool _cargando = false;

  /// Retorna el usuario autenticado actualmente en la aplicación.
  Usuario? get usuarioActual => _usuarioActual;

  /// Indica si existe una sesión activa válida.
  bool get estaAutenticado => _usuarioActual != null;

  /// Mensaje de error reactivo para notificaciones y alertas en la vista.
  String? get error => _error;

  /// Indicador de carga durante la verificación de credenciales.
  bool get cargando => _cargando;

  /// Inicia sesión comparando las credenciales contra la fuente de datos simulada.
  Future<bool> login(String nombreUsuario, String contrasena) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    // Pequeño retardo simulado para una experiencia de usuario realista
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final usuarioEncontrado = DatosSimulados.usuariosPrueba.firstWhere(
        (u) =>
            u.nombreUsuario.toLowerCase() == nombreUsuario.trim().toLowerCase() &&
            u.contrasena == contrasena,
      );

      _usuarioActual = usuarioEncontrado;
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Usuario o contraseña incorrectos. Verifique sus credenciales.';
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  /// Cierra la sesión activa y limpia los datos del usuario en memoria.
  void logout() {
    _usuarioActual = null;
    _error = null;
    _cargando = false;
    notifyListeners();
  }

  /// Descuenta saldo de la cuenta del usuario tras una recarga aprobada por "Débito de cuenta".
  void descontarSaldo(double monto) {
    if (_usuarioActual != null) {
      final nuevoSaldo = double.parse((_usuarioActual!.saldo - monto).toStringAsFixed(2));
      _usuarioActual = _usuarioActual!.copyWith(saldo: nuevoSaldo);
      notifyListeners();
    }
  }

  /// Limpia cualquier mensaje de error activo en el controlador.
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}

