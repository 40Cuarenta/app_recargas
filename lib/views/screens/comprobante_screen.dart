import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recarga_controller.dart';
import '../widgets/organisms/comprobante_detalle.dart';
import '../widgets/organisms/pago_exitoso_view.dart';

/// Pantalla 3: revisa la operación y muestra aquí mismo su confirmación.
class ComprobanteScreen extends StatelessWidget {
  const ComprobanteScreen({super.key});

  Future<void> _confirmar(BuildContext context) async {
    await context.read<RecargaController>().confirmarPago(
      authController: context.read<AuthController>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recarga = context.watch<RecargaController>();
    final usuario = context.watch<AuthController>().usuarioActual;
    final operadora = recarga.operadora;
    final comprobante = recarga.ultimoComprobante;
    return PopScope(
      canPop: !recarga.procesando,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            comprobante == null
                ? 'Comprobante de operación'
                : 'Pago confirmado',
          ),
          leading: IconButton(
            tooltip: 'Volver al formulario',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: recarga.procesando ? null : () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: comprobante != null
                    ? PagoExitosoView(
                        recarga: comprobante,
                        onVolverPrincipal: () => Navigator.pop(context),
                      )
                    : usuario == null || operadora == null
                    ? const Text('Primero completa los datos de la recarga.')
                    : ComprobanteDetalle(
                        numeroTelefono: recarga.numeroTelefono,
                        operadora: operadora,
                        tipo: recarga.tipo,
                        valorBase: recarga.valorBase,
                        paquete: recarga.paqueteSeleccionado,
                        metodoPago: recarga.metodoPago,
                        onMetodoPagoChanged: recarga.procesando
                            ? (_) {}
                            : recarga.setMetodoPago,
                        saldoDisponible: usuario.saldo,
                        comision: recarga.comision,
                        porcentajeComision: recarga.porcentajeComisionEfectivo,
                        total: recarga.total,
                        ganancia: recarga.ganancia,
                        isProcessing: recarga.procesando,
                        errorMessage: recarga.error,
                        onConfirmarPago: () => _confirmar(context),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
