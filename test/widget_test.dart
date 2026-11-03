import 'package:flutter_test/flutter_test.dart';
import 'package:app_recargas/main.dart';

void main() {
  testWidgets('Carga inicial de la aplicación en pantalla de login', (WidgetTester tester) async {
    // Construir la aplicación e iniciar frame
    await tester.pumpWidget(const AppRecargas());
    await tester.pumpAndSettle();

    // Verificar que renderiza el título del terminal de recargas
    expect(find.text('Recargas Ecuador'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
