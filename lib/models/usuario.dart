import 'paquete.dart';

/// Modelo inmutable que representa a un usuario o comerciante del punto de venta.
class Usuario {
  /// Identificador único del usuario en el sistema.
  final String id;

  /// Nombre de usuario para iniciar sesión (credencial).
  final String nombreUsuario;

  /// Contraseña de acceso (simulada para autenticación).
  final String contrasena;

  /// Nombre y apellido completo del operador o propietario de la cuenta.
  final String nombreCompleto;

  /// Saldo disponible en dólares (USD) para emitir recargas y combos.
  final double saldo;

  /// Paquete o combo activo en el terminal (opcional).
  final Paquete? comboActual;

  const Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.contrasena,
    required this.nombreCompleto,
    required this.saldo,
    this.comboActual,
  });

  /// Permite generar una copia inmutable modificando atributos específicos
  /// (por ejemplo al descontar saldo tras una recarga exitosa).
  Usuario copyWith({
    String? id,
    String? nombreUsuario,
    String? contrasena,
    String? nombreCompleto,
    double? saldo,
    Paquete? comboActual,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      contrasena: contrasena ?? this.contrasena,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      saldo: saldo ?? this.saldo,
      comboActual: comboActual ?? this.comboActual,
    );
  }
}

