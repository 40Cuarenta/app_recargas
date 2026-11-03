import '../../models/operadora.dart';
import '../../models/recarga.dart';

/// Clase utilitaria con validadores estáticos reutilizables para formularios Flutter.
/// Diseñados específicamente para las reglas comerciales de recargas móviles en Ecuador.
class Validators {
  Validators._();

  /// Valida que el usuario sea obligatorio y contenga al menos 4 caracteres.
  static String? validarUsuario(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre de usuario es obligatorio.';
    }
    if (value.trim().length < 4) {
      return 'El usuario debe tener al menos 4 caracteres.';
    }
    return null;
  }

  /// Valida que la contraseña sea obligatoria y contenga al menos 6 caracteres.
  static String? validarContrasena(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contraseña es obligatoria.';
    }
    if (value.trim().length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return null;
  }

  /// Valida el formato oficial de telefonía móvil celular en Ecuador:
  /// - Obligatorio
  /// - Exactamente 10 dígitos numéricos
  /// - Debe iniciar con '09' (ej. 0991234567, 0987654321)
  static String? validarTelefono(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número celular es obligatorio.';
    }
    final limpio = value.trim();

    // Comprobar que solo contenga dígitos
    final soloDigitosRegExp = RegExp(r'^[0-9]+$');
    if (!soloDigitosRegExp.hasMatch(limpio)) {
      return 'Solo se permiten dígitos numéricos (sin espacios ni guiones).';
    }

    if (limpio.length != 10) {
      return 'El número debe tener exactamente 10 dígitos (actual: ${limpio.length}).';
    }

    if (!limpio.startsWith('09')) {
      return 'El número debe iniciar con "09" (formato celular Ecuador).';
    }

    return null;
  }

  /// Valida el monto numérico de la recarga en un rango permitido (por defecto $1.00 a $100.00).
  static String? validarValorRecarga(
    String? value, {
    double minimo = 1.0,
    double maximo = 100.0,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'El monto a recargar es obligatorio.';
    }

    // Normalizar separadores decimales (permitir coma o punto)
    final limpio = value.trim().replaceAll(',', '.');
    final double? valor = double.tryParse(limpio);

    if (valor == null) {
      return 'Ingrese un monto numérico válido (ej. 5.00).';
    }

    if (valor < minimo) {
      return 'El monto mínimo de recarga es \$${minimo.toStringAsFixed(2)}.';
    }

    if (valor > maximo) {
      return 'El monto máximo permitido es \$${maximo.toStringAsFixed(2)}.';
    }

    return null;
  }

  /// Valida que se haya seleccionado una operadora móvil antes de avanzar.
  static String? validarOperadora(Operadora? operadora) {
    if (operadora == null) {
      return 'Debe seleccionar una operadora móvil para continuar.';
    }
    return null;
  }

  /// Valida que se haya seleccionado un método de pago válido antes de procesar la recarga.
  static String? validarMetodoPago(MetodoPago? metodo) {
    if (metodo == null) {
      return 'Debe seleccionar un método de pago ("Débito de cuenta" o "Tarjeta").';
    }
    return null;
  }
}

