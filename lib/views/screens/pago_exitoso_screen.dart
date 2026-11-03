import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/atoms/app_button.dart';
import '../widgets/atoms/app_title.dart';
import '../widgets/organisms/pago_exitoso_view.dart';

/// Pantalla 7: Confirmación y Pago Exitoso (Mockup 4).
/// Muestra la animación de confirmación, el comprobante digital final con ID de autorización,
/// y un botón para retornar a la Pantalla Principal limpiando la pila de navegación.
class PagoExitosoScreen extends StatelessWidget {
  const PagoExitosoScreen({super.key});

  void _volverAPrincipal(BuildContext context) {
    // 1. Limpiar primero la pila completa y navegar a Home
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );

    // 2. Reiniciar el estado del flujo de recargas
    context.read<RecargaController>().reiniciar();
  }

  @override
  Widget build(BuildContext context) {
    final recargaController = context.watch<RecargaController>();
    final comprobante = recargaController.ultimoComprobante;

    // Validación defensiva segura sin addPostFrameCallback para evitar condiciones de carrera
    if (comprobante == null) {
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
                    Icons.check_circle_outline_rounded,
                    size: 64,
                    color: AppColors.primario,
                  ),
                  const SizedBox(height: 16),
                  const AppTitle(
                    text: 'Operación Finalizada',
                    size: AppTitleSize.medio,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Volver a Pantalla Principal',
                    onPressed: () => _volverAPrincipal(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _volverAPrincipal(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.fondo,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: PagoExitosoView(
                  recarga: comprobante,
                  onVolverPrincipal: () => _volverAPrincipal(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
