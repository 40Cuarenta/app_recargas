import 'package:flutter_test/flutter_test.dart';
import 'package:app_recargas/controllers/auth_controller.dart';
import 'package:app_recargas/controllers/recarga_controller.dart';
import 'package:app_recargas/core/utils/validators.dart';
import 'package:app_recargas/data/datos_simulados.dart';
import 'package:app_recargas/models/recarga.dart';

void main() {
  group('1. Pruebas de Login y Autenticación', () {
    test('Validación de usuario: vacío y corto (< 4 caracteres)', () {
      expect(Validators.validarUsuario(''), isNotNull);
      expect(Validators.validarUsuario('abc'), isNotNull);
      expect(Validators.validarUsuario('cajero1'), isNull);
    });

    test('Validación de contraseña: vacía y corta (< 6 caracteres)', () {
      expect(Validators.validarContrasena(''), isNotNull);
      expect(Validators.validarContrasena('12345'), isNotNull);
      expect(Validators.validarContrasena('123456'), isNull);
    });

    test('Login con credenciales incorrectas vs correctas', () async {
      final auth = AuthController();

      // Credenciales inválidas
      final loginInvalido = await auth.login('cajero1', 'clave_erronea');
      expect(loginInvalido, isFalse);
      expect(auth.error, isNotNull);
      expect(auth.usuarioActual, isNull);

      // Credenciales válidas
      final loginValido = await auth.login('cajero1', '123456');
      expect(loginValido, isTrue);
      expect(auth.error, isNull);
      expect(auth.usuarioActual, isNotNull);
      expect(auth.usuarioActual!.nombreUsuario, 'cajero1');
      expect(auth.usuarioActual!.saldo, 150.00);
    });
  });

  group('2. Pruebas de Validación de Número Telefónico (Ecuador)', () {
    test('Número con letras', () {
      expect(
        Validators.validarTelefono('099123456a'),
        contains('Solo se permiten dígitos numéricos'),
      );
    });

    test('Número con menos de 10 dígitos', () {
      expect(
        Validators.validarTelefono('09912345'),
        contains('exactamente 10 dígitos'),
      );
    });

    test('Número que no inicia en 09', () {
      expect(
        Validators.validarTelefono('0891234567'),
        contains('iniciar con "09"'),
      );
    });

    test('Número celular válido', () {
      expect(Validators.validarTelefono('0991234567'), isNull);
      expect(Validators.validarTelefono('0987654321'), isNull);
    });
  });

  group('3. Pruebas de Valor de Recarga', () {
    test('Valor vacío', () {
      expect(
        Validators.validarValorRecarga(''),
        contains('obligatorio'),
      );
    });

    test('Valor 0', () {
      expect(
        Validators.validarValorRecarga('0'),
        contains('mínimo'),
      );
    });

    test('Valor negativo', () {
      expect(
        Validators.validarValorRecarga('-5'),
        contains('mínimo'),
      );
    });

    test('Valor mayor al máximo (\$100.00)', () {
      expect(
        Validators.validarValorRecarga('150'),
        contains('máximo permitido'),
      );
    });

    test('Valor válido (\$10.00)', () {
      expect(Validators.validarValorRecarga('10.00'), isNull);
    });
  });

  group('4. Lógica Financiera: Recarga \$10 con comisión 3% -> Total \$10.30', () {
    test('Liquidación exacta de recarga de \$10.00 con comisión del 3%', () {
      final operadoraMovistar = DatosSimulados.operadoras.firstWhere(
        (o) => o.id == 'movistar',
      );
      expect(operadoraMovistar.porcentajeComision, 0.03);

      final liquidacion = DatosSimulados.calcularLiquidacion(
        operadora: operadoraMovistar,
        valor: 10.00,
      );

      // Comisión = 10 * 3% = $0.30
      expect(liquidacion.comision, 0.30);
      // Total a pagar = 10 + 0.30 = $10.30
      expect(liquidacion.total, 10.30);
      // Ganancia del local (4.5% de Movistar) = $0.45
      expect(liquidacion.ganancia, 0.45);
    });
  });

  group('5. Validación de Saldo Insuficiente en Pago con Débito', () {
    test('Rechaza débito de cuenta si el total a pagar supera el saldo', () async {
      final auth = AuthController();
      await auth.login('ventas_sur', 'recargas2026'); // saldo inicial: $75.25

      final recargas = RecargaController();
      final operadora = DatosSimulados.operadoras.first;
      recargas.setOperadora(operadora);
      recargas.setNumeroTelefono('0991234567');
      recargas.setValorRecarga(100.00); // Monto total $103.00 > saldo $75.25
      recargas.setMetodoPago(MetodoPago.debitoCuenta);

      final saldoSuficiente = recargas.validarSaldoSuficiente(auth.usuarioActual!.saldo);
      expect(saldoSuficiente, isFalse);
      expect(recargas.error, contains('Saldo insuficiente'));

      final comprobante = await recargas.confirmarPago(authController: auth);
      expect(comprobante, isNull);
    });
  });

  group('6. Cierre de Sesión y Reinicio del Flujo', () {
    test('Logout limpia usuario y reiniciar() restablece todo el estado transaccional', () async {
      final auth = AuthController();
      await auth.login('cajero1', '123456');
      expect(auth.estaAutenticado, isTrue);

      // Cierre de sesión
      auth.logout();
      expect(auth.estaAutenticado, isFalse);
      expect(auth.usuarioActual, isNull);

      // Mutar estado de recargas
      final recargas = RecargaController();
      recargas.setNumeroTelefono('0991234567');
      recargas.setOperadora(DatosSimulados.operadoras.first);
      recargas.setValorRecarga(25.00);
      recargas.setTipoRecarga(TipoRecarga.recarga);

      // Reinicio del flujo
      recargas.reiniciar();
      expect(recargas.numeroTelefono, isEmpty);
      expect(recargas.operadora, isNull);
      expect(recargas.valorRecarga, 0.0);
      expect(recargas.paqueteSeleccionado, isNull);
      expect(recargas.error, isNull);
      expect(recargas.ultimoComprobante, isNull);
    });
  });
}

