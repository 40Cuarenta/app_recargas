import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/atoms/app_title.dart';
import '../widgets/organisms/home_header.dart';
import '../widgets/organisms/resumen_cuenta_section.dart';

/// Pantalla 2: Principal / Dashboard (Mockup 1).
/// Presenta la bienvenida, el estado de "Mi Combo", "Mi saldo actual",
/// el acceso a "Recargas y combos" y la opción segura de "Cerrar sesión" con confirmación.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const AppTitle(
          text: '¿Cerrar sesión?',
          size: AppTitleSize.pequeno,
        ),
        content: const Text(
          '¿Está seguro de que desea salir del terminal de recargas? '
          'Deberá ingresar sus credenciales nuevamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: AppTheme.botonPeligro,
            onPressed: () {
              Navigator.pop(dialogContext);
              // Cerrar sesión y reiniciar flujos
              context.read<AuthController>().logout();
              context.read<RecargaController>().reiniciar();

              // Regresar a login limpiando todo el historial
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _iniciarFlujoRecarga(BuildContext context) {
    // Reiniciar cualquier estado previo antes de iniciar una nueva transacción
    context.read<RecargaController>().reiniciar();
    Navigator.pushNamed(context, AppRoutes.numero);
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final usuario = authController.usuarioActual;

    // Validación defensiva segura si no hay sesión activa
    if (usuario == null) {
      return Scaffold(
        backgroundColor: AppColors.fondo,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: AppColors.textoSecundario,
                  ),
                  const SizedBox(height: 16),
                  const AppTitle(
                    text: 'Sesión Finalizada',
                    size: AppTitleSize.medio,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    child: const Text('Ir a Inicio de Sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabecera superior con bienvenida
                  HomeHeader(
                    usuario: usuario,
                    onInfoTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Punto de Venta #${usuario.id} • Operador: ${usuario.nombreCompleto}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Organismo: Sección con Mi Combo, Saldo actual y botones
                  ResumenCuentaSection(
                    usuario: usuario,
                    onNuevaRecarga: () => _iniciarFlujoRecarga(context),
                    onCerrarSesion: () => _confirmarCerrarSesion(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
