import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/recarga.dart';
import '../widgets/atoms/app_button.dart';
import '../widgets/atoms/app_title.dart';
import '../widgets/organisms/comprobante_detalle.dart';

/// Pantalla 6: Comprobante y Pre-liquidación de Pago (Paso 4 del flujo - Mockup 4).
/// Presenta el resumen completo de la transacción, selección de método de pago,
/// comisión calculada y monto total a pagar.
/// Valida la suficiencia de fondos en caso de débito de cuenta antes de autorizar.
class ComprobanteScreen extends StatelessWidget {
  const ComprobanteScreen({super.key});

  Future<void> _confirmarYProcesar(BuildContext context) async {
    final authController = context.read<AuthController>();
    final recargaController = context.read<RecargaController>();

    final usuario = authController.usuarioActual;
    if (usuario == null) return;

    // Validación de saldo previo si el pago es débito de cuenta
    if (recargaController.metodoPago == MetodoPago.debitoCuenta) {
      if (usuario.saldo < recargaController.total) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Saldo insuficiente en cuenta (\$${usuario.saldo.toStringAsFixed(2)}). '
              'El total requerido es \$${recargaController.total.toStringAsFixed(2)}.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }
    }

    // Procesar la confirmación y descuento de saldo
    final comprobante = await recargaController.confirmarPago(
      authController: authController,
    );

    if (context.mounted && comprobante != null) {
      // Navegar a la Pantalla de Éxito
      Navigator.pushNamed(context, AppRoutes.pagoExitoso);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final recargaController = context.watch<RecargaController>();

    final operadora = recargaController.operadora;
    final usuario = authController.usuarioActual;

    // Validación defensiva segura sin addPostFrameCallback para evitar condiciones de carrera
    if (operadora == null || usuario == null) {
      return Scaffold(
        backgroundColor: AppColors.fondo,
        appBar: AppBar(
          title: const Text('Comprobante de Operación'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              }
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  const AppTitle(
                    text: 'Datos Incompletos',
                    size: AppTitleSize.medio,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No se han completado los pasos previos de la recarga.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Volver a Pantalla Principal',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
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
      appBar: AppBar(
        title: const Text('Comprobante de Operación'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.nuevaRecarga);
            }
          },
          tooltip: 'Regresar a la configuración de la recarga',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ComprobanteDetalle(
                numeroTelefono: recargaController.numeroTelefono,
                operadora: operadora,
                tipo: recargaController.tipo,
                valorBase: recargaController.valorBase,
                paquete: recargaController.paqueteSeleccionado,
                metodoPago: recargaController.metodoPago,
                onMetodoPagoChanged: recargaController.setMetodoPago,
                saldoDisponible: usuario.saldo,
                comision: recargaController.comision,
                porcentajeComision: recargaController.porcentajeComisionEfectivo,
                total: recargaController.total,
                ganancia: recargaController.ganancia,
                isProcessing: recargaController.procesando,
                errorMessage: recargaController.error,
                onConfirmarPago: () => _confirmarYProcesar(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
