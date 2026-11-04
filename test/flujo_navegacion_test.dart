import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_recargas/main.dart';
import 'package:app_recargas/core/routes/app_routes.dart';
import 'package:app_recargas/models/operadora.dart';
import 'package:app_recargas/views/screens/comprobante_screen.dart';

Future<void> pulsar(WidgetTester tester, Finder objetivo) async {
  await tester.ensureVisible(objetivo);
  await tester.tap(objetivo);
  await tester.pumpAndSettle();
}

Future<void> iniciar(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 850);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const AppRecargas());
  await tester.pumpAndSettle();
  await pulsar(tester, find.text('Iniciar sesión'));
}

Future<void> elegirOperadora(WidgetTester tester, String nombre) async {
  await pulsar(tester, find.byType(DropdownButtonFormField<Operadora>));
  await pulsar(tester, find.text(nombre).last);
}

void main() {
  testWidgets('Limpiar borra credenciales, validaciones y el error de acceso', (
    tester,
  ) async {
    await tester.pumpWidget(const AppRecargas());
    await tester.pumpAndSettle();
    await pulsar(tester, find.text('Limpiar'));
    await pulsar(tester, find.text('Iniciar sesión'));
    expect(find.text('El nombre de usuario es obligatorio.'), findsOneWidget);
    expect(find.text('La contraseña es obligatoria.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'incorrecto');
    await tester.enterText(find.byType(TextFormField).last, 'incorrecta');
    await pulsar(tester, find.text('Iniciar sesión'));
    expect(
      find.textContaining('Usuario o contraseña incorrectos'),
      findsWidgets,
    );
    await pulsar(tester, find.text('Limpiar'));
    for (final campo in tester.widgetList<TextFormField>(
      find.byType(TextFormField),
    )) {
      expect(campo.controller!.text, isEmpty);
    }
    expect(
      find.textContaining('Usuario o contraseña incorrectos'),
      findsNothing,
    );
    expect(find.text('El nombre de usuario es obligatorio.'), findsNothing);
    expect(find.text('La contraseña es obligatoria.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Tres rutas: editar, pagar con débito, actualizar saldo y cerrar sesión',
    (tester) async {
      expect(AppRoutes.routes.keys.toSet(), {'/', '/home', '/comprobante'});
      await iniciar(tester);
      expect(find.text('Edison Proaño'), findsOneWidget);
      await elegirOperadora(tester, 'Movistar');
      await pulsar(tester, find.text('REVISAR RECARGA'));
      expect(find.byType(ComprobanteScreen), findsOneWidget);
      expect(find.text('Total a Pagar (\$5.15)'), findsOneWidget);
      await pulsar(tester, find.byTooltip('Volver al formulario'));
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).first)
            .controller!
            .text,
        '0991234567',
      );
      await tester.enterText(find.byType(TextFormField).last, '10');
      await pulsar(tester, find.text('REVISAR RECARGA'));
      expect(find.text('Ganancia estimada (4,5 %):'), findsOneWidget);
      expect(find.textContaining('Reducción de 1 punto'), findsNothing);
      await pulsar(tester, find.text('Total a Pagar (\$10.30)'));
      expect(find.text('Confirmación de Pago'), findsOneWidget);
      expect(find.byType(ComprobanteScreen), findsOneWidget);
      await pulsar(tester, find.text('VOLVER A PANTALLA PRINCIPAL'));
      expect(find.text('\$139.70'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).first)
            .controller!
            .text,
        isEmpty,
      );
      await pulsar(tester, find.byTooltip('Cerrar sesión'));
      await pulsar(
        tester,
        find.widgetWithText(ElevatedButton, 'Cerrar sesión'),
      );
      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Paquete MaxiPlus y tarjeta conservan saldo y muestran 6,5 por ciento',
    (tester) async {
      await iniciar(tester);
      await elegirOperadora(tester, 'MaxiPlus');
      await pulsar(tester, find.text('Paquetes'));
      await pulsar(tester, find.text('Maxi Premium Mes'));
      await pulsar(tester, find.text('Tarjeta'));
      await pulsar(tester, find.text('REVISAR RECARGA'));
      expect(find.text('Ganancia estimada (6,5 %):'), findsOneWidget);
      expect(find.text('+\$1.30'), findsOneWidget);
      expect(find.textContaining('Reducción de 1 punto'), findsOneWidget);
      await pulsar(tester, find.text('Total a Pagar (\$20.80)'));
      expect(find.text('Confirmación de Pago'), findsOneWidget);
      await pulsar(tester, find.text('VOLVER A PANTALLA PRINCIPAL'));
      expect(find.text('\$150.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
