import 'package:flutter_test/flutter_test.dart';
import 'package:app_recargas/controllers/auth_controller.dart';
import 'package:app_recargas/controllers/recarga_controller.dart';
import 'package:app_recargas/core/utils/formateadores.dart';
import 'package:app_recargas/core/utils/validators.dart';
import 'package:app_recargas/data/datos_simulados.dart';

void main() {
  test('El formato conserva porcentajes fraccionarios reales', () {
    expect(formatearPorcentaje(0.045), '4,5');
    expect(formatearPorcentaje(0.055), '5,5');
    expect(formatearPorcentaje(0.065), '6,5');
    expect(formatearPorcentaje(0.03), '3');
  });

  test('Solo acepta montos finitos con hasta dos decimales', () {
    for (final entrada in [
      'NaN',
      'Infinity',
      '1e1',
      '1.234',
      '-1',
      '0',
      '101',
    ]) {
      expect(
        Validators.validarValorRecarga(entrada),
        isNotNull,
        reason: entrada,
      );
    }
    expect(Validators.validarValorRecarga('10,50'), isNull);
    expect(Validators.validarValorRecarga('100'), isNull);
  });

  test('El descuento desde diez respeta el piso del tres por ciento', () {
    for (final operadora in DatosSimulados.operadoras) {
      final antes = DatosSimulados.calcularPorcentajeComisionEfectivo(
        operadora: operadora,
        valor: 9.99,
      );
      final despues = DatosSimulados.calcularPorcentajeComisionEfectivo(
        operadora: operadora,
        valor: 10,
      );
      expect(antes, operadora.porcentajeComision);
      expect(despues, closeTo(antes > 0.03 ? antes - 0.01 : antes, 0.000001));
    }
  });

  test('Confirmaciones repetidas no descuentan el saldo dos veces', () async {
    final auth = AuthController();
    await auth.login('cajero1', '123456');
    final recarga = RecargaController();
    recarga.setNumeroTelefono('0991234567');
    recarga.setOperadora(
      DatosSimulados.operadoras.firstWhere((o) => o.id == 'movistar'),
    );
    recarga.setValorRecarga(10);
    final primera = recarga.confirmarPago(authController: auth);
    final simultanea = await recarga.confirmarPago(authController: auth);
    expect(simultanea, isNull);
    final comprobante = await primera;
    expect(comprobante, isNotNull);
    expect(auth.usuarioActual!.saldo, 139.70);
    expect(
      await recarga.confirmarPago(authController: auth),
      same(comprobante),
    );
    expect(auth.usuarioActual!.saldo, 139.70);
  });
}
