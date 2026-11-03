import 'operadora.dart';
import 'paquete.dart';

/// Modalidad de la operación: recarga de saldo monetario o activación de paquete/combo.
enum TipoRecarga {
  recarga,
  paquete,
}

/// Medios de pago aceptados para procesar la transacción.
enum MetodoPago {
  debitoCuenta,
  tarjeta,
}

/// Modelo inmutable que representa una transacción de recarga o combo móvil.
class Recarga {
  /// Número telefónico ecuatoriano de destino (10 dígitos, ej. "0991234567").
  final String numeroTelefono;

  /// Compañía operadora de telecomunicaciones asociada a la recarga.
  final Operadora operadora;

  /// Tipo de operación efectuada: recarga monetaria directa o adquisición de combo.
  final TipoRecarga tipo;

  /// Monto nominal o facial del servicio en dólares (USD).
  final double valorBase;

  /// Combo seleccionado en caso de que el tipo sea [TipoRecarga.paquete].
  final Paquete? paquete;

  /// Método de pago seleccionado por el cliente ("Débito de cuenta" o "Tarjeta").
  final MetodoPago metodoPago;

  /// Valor de la comisión calculada según la operadora y el monto.
  final double comision;

  /// Monto total liquidado a pagar por el cliente (valorBase + comision).
  final double total;

  /// Margen de utilidad o ganancia neta acreditada al punto de venta.
  final double ganancia;

  /// Marca temporal (timestamp) exacta en que se procesó la transacción.
  final DateTime fecha;

  /// Identificador único o código de autorización de la transacción.
  final String idTransaccion;

  const Recarga({
    required this.numeroTelefono,
    required this.operadora,
    required this.tipo,
    required this.valorBase,
    this.paquete,
    required this.metodoPago,
    required this.comision,
    required this.total,
    required this.ganancia,
    required this.fecha,
    required this.idTransaccion,
  });

  /// Permite generar una copia inmutable modificando atributos específicos.
  Recarga copyWith({
    String? numeroTelefono,
    Operadora? operadora,
    TipoRecarga? tipo,
    double? valorBase,
    Paquete? paquete,
    MetodoPago? metodoPago,
    double? comision,
    double? total,
    double? ganancia,
    DateTime? fecha,
    String? idTransaccion,
  }) {
    return Recarga(
      numeroTelefono: numeroTelefono ?? this.numeroTelefono,
      operadora: operadora ?? this.operadora,
      tipo: tipo ?? this.tipo,
      valorBase: valorBase ?? this.valorBase,
      paquete: paquete ?? this.paquete,
      metodoPago: metodoPago ?? this.metodoPago,
      comision: comision ?? this.comision,
      total: total ?? this.total,
      ganancia: ganancia ?? this.ganancia,
      fecha: fecha ?? this.fecha,
      idTransaccion: idTransaccion ?? this.idTransaccion,
    );
  }
}

