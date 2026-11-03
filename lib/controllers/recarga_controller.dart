import 'package:flutter/material.dart';
import '../data/datos_simulados.dart';
import '../models/operadora.dart';
import '../models/paquete.dart';
import '../models/recarga.dart';
import 'auth_controller.dart';

/// Controlador de Recargas y Operaciones Transaccionales (ChangeNotifier).
/// Mantiene y administra el estado completo del flujo de recarga:
/// Paso 1: Número telefónico
/// Paso 2: Selección de operadora
/// Paso 3: Selección de modalidad (Recarga o Paquete) y monto
/// Paso 4: Selección de método de pago y comprobante
/// Paso 5: Confirmación de pago y generación de recibo
class RecargaController extends ChangeNotifier {
  // --- Estado del Flujo Transaccional ---
  String _numeroTelefono = '';
  Operadora? _operadora;
  TipoRecarga _tipo = TipoRecarga.recarga;
  double _valorRecarga = 0.0;
  Paquete? _paqueteSeleccionado;
  MetodoPago _metodoPago = MetodoPago.debitoCuenta;

  int _pasoActual = 1;
  String? _error;
  bool _procesando = false;
  Recarga? _ultimoComprobante;

  // --- Getters de Lectura Reactiva ---
  int get pasoActual => _pasoActual;
  String get numeroTelefono => _numeroTelefono;
  Operadora? get operadora => _operadora;
  TipoRecarga get tipo => _tipo;
  double get valorRecarga => _valorRecarga;
  Paquete? get paqueteSeleccionado => _paqueteSeleccionado;
  MetodoPago get metodoPago => _metodoPago;
  String? get error => _error;
  bool get procesando => _procesando;
  Recarga? get ultimoComprobante => _ultimoComprobante;

  // --- Lógica de Negocio y Desglose Financiero ---

  /// Monto nominal o base de la transacción según la modalidad escogida.
  double get valorBase {
    if (_tipo == TipoRecarga.paquete && _paqueteSeleccionado != null) {
      return _paqueteSeleccionado!.precio;
    }
    return _valorRecarga;
  }

  /// Porcentaje de comisión efectivo aplicado según la operadora y el monto.
  double get porcentajeComisionEfectivo {
    if (_operadora == null || valorBase <= 0) return 0.0;
    return DatosSimulados.calcularPorcentajeComisionEfectivo(
      operadora: _operadora!,
      valor: valorBase,
    );
  }

  /// Valor de la comisión calculada para el cliente en dólares (USD).
  double get comision {
    if (_operadora == null || valorBase <= 0) return 0.0;
    return DatosSimulados.calcularLiquidacion(
      operadora: _operadora!,
      valor: valorBase,
    ).comision;
  }

  /// Total a liquidar y pagar por el cliente (valorBase + comisión).
  double get total {
    if (_operadora == null || valorBase <= 0) return 0.0;
    return DatosSimulados.calcularLiquidacion(
      operadora: _operadora!,
      valor: valorBase,
    ).total;
  }

  /// Ganancia o comisión comercial que se acredita al establecimiento.
  double get ganancia {
    if (_operadora == null || valorBase <= 0) return 0.0;
    return DatosSimulados.calcularLiquidacion(
      operadora: _operadora!,
      valor: valorBase,
    ).ganancia;
  }

  // --- Métodos de Mutación del Flujo ---

  /// Paso 1: Establece el número de teléfono destinatario de la recarga.
  void setNumeroTelefono(String numero) {
    _numeroTelefono = numero.trim();
    _error = null;
    notifyListeners();
  }

  /// Paso 2: Establece la operadora seleccionada y valida compatibilidad de paquetes.
  void setOperadora(Operadora nuevaOperadora) {
    _operadora = nuevaOperadora;
    // Si ya había un paquete seleccionado pero pertenece a otra operadora, se reinicia
    if (_paqueteSeleccionado != null &&
        _paqueteSeleccionado!.operadoraId != nuevaOperadora.id) {
      _paqueteSeleccionado = null;
    }
    _error = null;
    notifyListeners();
  }

  /// Paso 3: Alterna entre modalidad de recarga monetaria directa o adquisición de paquetes.
  void setTipoRecarga(TipoRecarga nuevoTipo) {
    _tipo = nuevoTipo;
    _error = null;
    notifyListeners();
  }

  /// Paso 3a: Establece el valor monetario directo cuando se recarga saldo.
  void setValorRecarga(double valor) {
    _tipo = TipoRecarga.recarga;
    _valorRecarga = valor;
    _paqueteSeleccionado = null;
    _error = null;
    notifyListeners();
  }

  /// Paso 3b: Establece el combo seleccionado cuando se adquiere un paquete.
  void setPaquete(Paquete paquete) {
    _tipo = TipoRecarga.paquete;
    _paqueteSeleccionado = paquete;
    _valorRecarga = paquete.precio;
    _error = null;
    notifyListeners();
  }

  /// Paso 4: Establece el método de pago seleccionado por el cliente.
  void setMetodoPago(MetodoPago metodo) {
    _metodoPago = metodo;
    _error = null;
    notifyListeners();
  }

  // --- Validaciones Transaccionales ---

  /// Valida si el saldo actual del punto de venta es suficiente cuando el pago es por "Débito de cuenta".
  bool validarSaldoSuficiente(double saldoUsuario) {
    if (_metodoPago == MetodoPago.debitoCuenta) {
      if (saldoUsuario < total) {
        _error =
            'Saldo insuficiente en su cuenta (\$${saldoUsuario.toStringAsFixed(2)}). '
            'El total requerido para procesar la transacción es \$${total.toStringAsFixed(2)}.';
        notifyListeners();
        return false;
      }
    }
    _error = null;
    return true;
  }

  /// Ejecuta y confirma la transacción de recarga:
  /// - Valida datos obligatorios del flujo.
  /// - Valida saldo suficiente en caso de débito de cuenta.
  /// - Descuenta el total del saldo del usuario autenticado.
  /// - Genera un identificador único (idTransaccion) y timestamp de fecha.
  /// - Devuelve el modelo inmutable [Recarga] como comprobante de pago.
  Future<Recarga?> confirmarPago({
    required AuthController authController,
  }) async {
    _procesando = true;
    _error = null;
    notifyListeners();

    // 1. Validar integridad de datos
    if (_numeroTelefono.isEmpty || _operadora == null || valorBase <= 0) {
      _error = 'Datos de recarga incompletos. Verifique los pasos anteriores.';
      _procesando = false;
      notifyListeners();
      return null;
    }

    final usuario = authController.usuarioActual;
    if (usuario == null) {
      _error = 'No se ha detectado una sesión de usuario activa.';
      _procesando = false;
      notifyListeners();
      return null;
    }

    // 2. Validar saldo si el método de pago es débito de cuenta
    if (_metodoPago == MetodoPago.debitoCuenta) {
      final tieneSaldo = validarSaldoSuficiente(usuario.saldo);
      if (!tieneSaldo) {
        _procesando = false;
        notifyListeners();
        return null;
      }
      // Descontar saldo del usuario
      authController.descontarSaldo(total);
    }

    // Simular latencia de red de la pasarela de pagos
    await Future.delayed(const Duration(milliseconds: 600));

    // 3. Generar comprobante inmutable con ID único
    final timestamp = DateTime.now();
    final idTransaccion =
        'REC-${timestamp.millisecondsSinceEpoch.toRadixString(36).toUpperCase()}';

    final comprobante = Recarga(
      numeroTelefono: _numeroTelefono,
      operadora: _operadora!,
      tipo: _tipo,
      valorBase: valorBase,
      paquete: _tipo == TipoRecarga.paquete ? _paqueteSeleccionado : null,
      metodoPago: _metodoPago,
      comision: comision,
      total: total,
      ganancia: ganancia,
      fecha: timestamp,
      idTransaccion: idTransaccion,
    );

    _ultimoComprobante = comprobante;
    _procesando = false;
    _error = null;
    notifyListeners();

    return comprobante;
  }

  /// Paso actual del flujo de recargas (1 a 4).
  void setPasoActual(int paso) {
    _pasoActual = paso;
  }

  /// Reinicia todos los estados del flujo de recarga para permitir una nueva operación.
  void reiniciar() {
    _pasoActual = 1;
    _numeroTelefono = '';
    _operadora = null;
    _tipo = TipoRecarga.recarga;
    _valorRecarga = 0.0;
    _paqueteSeleccionado = null;
    _metodoPago = MetodoPago.debitoCuenta;
    _error = null;
    _procesando = false;
    _ultimoComprobante = null;
    notifyListeners();
  }
}

