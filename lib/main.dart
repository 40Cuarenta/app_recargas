import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/recarga_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRecargas());
}

/// Widget raíz de la aplicación de Recargas Electrónicas Ecuador.
/// Configura la inyección de dependencias con [MultiProvider], el tema propio basado en
/// Material 3, la ruta inicial en login y el sistema de navegación por rutas nombradas.
class AppRecargas extends StatelessWidget {
  const AppRecargas({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RecargaController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recargas Ecuador',
        theme: AppTheme.temaClaro,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        onUnknownRoute: AppRoutes.onUnknownRoute,
      ),
    );
  }
}
