import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/datos_simulados.dart';
import '../../models/operadora.dart';
import '../widgets/organisms/operadoras_grid.dart';

/// Pantalla 4: Selección de Operadora Móvil (Paso 2 del flujo - Mockup 2).
/// Presenta el catálogo de operadoras (Tigo, Movistar, CNT, Tuenti, Aki Móvil, etc.)
/// y sus respectivas comisiones asociadas.
class OperadorasScreen extends StatelessWidget {
  const OperadorasScreen({super.key});

  void _seleccionarOperadora(BuildContext context, Operadora operadora) {
    final controller = context.read<RecargaController>();
    controller.setOperadora(operadora);
    controller.setPasoActual(3);

    // Navegar al Paso 3: Selección de Modalidad y Monto
    Navigator.pushNamed(context, AppRoutes.nuevaRecarga);
  }

  void _regresar(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recargaController = context.watch<RecargaController>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _regresar(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.fondo,
        appBar: AppBar(
          title: const Text('Paso 2 de 4'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _regresar(context),
            tooltip: 'Regresar al número de recarga',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: OperadorasGrid(
                  operadoras: DatosSimulados.operadoras,
                  operadoraSeleccionada: recargaController.operadora,
                  onOperadoraSeleccionada: (op) => _seleccionarOperadora(context, op),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
