import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_recargas/main.dart';

void main() {
  testWidgets('Flujo completo: login, recarga, retorno a home, retroceso paso a paso y logout',
      (WidgetTester tester) async {
    // Ajustar resolución del entorno de pruebas
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Iniciar App
    await tester.pumpWidget(const AppRecargas());
    await tester.pumpAndSettle();

    // Validar pantalla de login
    expect(find.text('Iniciar sesión'), findsOneWidget);

    // Iniciar sesión con cajero1 (prellenado por defecto)
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    // 2. Estamos en HomeScreen (Bienvenida y opciones principales)
    expect(find.text('RECARGAS Y COMBOS'), findsOneWidget);
    expect(find.text('Edison Proaño'), findsOneWidget);

    // Iniciar flujo de recarga
    await tester.tap(find.text('RECARGAS Y COMBOS'));
    await tester.pumpAndSettle();

    // 3. Paso 1: Número
    expect(find.text('Paso 1 de 4'), findsOneWidget);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // 4. Paso 2: Operadoras
    expect(find.text('Paso 2 de 4'), findsOneWidget);
    expect(find.text('Movistar'), findsOneWidget);
    // Tap en Movistar
    await tester.tap(find.text('Movistar'));
    await tester.pumpAndSettle();

    // 5. Paso 3: Monto / Combos
    expect(find.text('Paso 3 de 4'), findsOneWidget);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // 6. Paso 4: Comprobante
    expect(find.text('Comprobante de Operación'), findsOneWidget);
    // Presionar el botón de Total a Pagar
    final botonPagar = find.widgetWithText(ElevatedButton, 'Total a Pagar (\$5.15)');
    expect(botonPagar, findsOneWidget);
    await tester.tap(botonPagar);
    await tester.pumpAndSettle();

    // 7. Paso 5: Pago Exitoso
    expect(find.text('Confirmación de Pago'), findsOneWidget);
    expect(find.text('VOLVER A PANTALLA PRINCIPAL'), findsOneWidget);

    // 8. Pulsar "VOLVER A PANTALLA PRINCIPAL"
    await tester.tap(find.text('VOLVER A PANTALLA PRINCIPAL'));
    await tester.pumpAndSettle();

    // VERIFICACIÓN CRÍTICA: Debe estar en HOME, NUNCA en "Paso 2 de 4"
    expect(find.text('RECARGAS Y COMBOS'), findsOneWidget);
    expect(find.text('Paso 2 de 4'), findsNothing);

    // 9. Iniciar otra recarga para probar retroceso paso a paso
    await tester.tap(find.text('RECARGAS Y COMBOS'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 4'), findsOneWidget);

    // Avanzar a Paso 2
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 4'), findsOneWidget);

    // Avanzar a Paso 3 (seleccionar CNT)
    await tester.tap(find.text('CNT'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 3 de 4'), findsOneWidget);

    // Avanzar a Paso 4
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();
    expect(find.text('Comprobante de Operación'), findsOneWidget);

    // RETROCEDER PASO A PASO CON FLECHAS DE RETROCESO:
    // Desde Paso 4 retroceder a Paso 3
    await tester.tap(find.byTooltip('Regresar a la configuración de la recarga'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 3 de 4'), findsOneWidget);

    // Desde Paso 3 retroceder a Paso 2
    await tester.tap(find.byTooltip('Regresar a la selección de operadoras'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 4'), findsOneWidget);

    // Desde Paso 2 retroceder a Paso 1
    await tester.tap(find.byTooltip('Regresar al número de recarga'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 4'), findsOneWidget);

    // Desde Paso 1 retroceder a Home (debe regresar al Home limpiamente sin pantalla negra)
    await tester.tap(find.byTooltip('Regresar a la pantalla principal'));
    await tester.pumpAndSettle();
    expect(find.text('RECARGAS Y COMBOS'), findsOneWidget);

    // 10. Cerrar sesión
    await tester.tap(find.text('CERRAR SESIÓN'));
    await tester.pumpAndSettle();
    expect(find.text('¿Cerrar sesión?'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();

    // Confirmar que regresó al Login
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('RECARGAS Y COMBOS'), findsNothing);
  });
}
