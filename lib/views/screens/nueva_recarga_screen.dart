import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/datos_simulados.dart';
import '../../models/paquete.dart';
import '../../models/recarga.dart';
import '../widgets/atoms/app_button.dart';
import '../widgets/atoms/app_title.dart';
import '../widgets/organisms/seleccion_monto_section.dart';

/// Pantalla 5: Configuración de Recarga / Combo (Paso 3 del flujo - Mockup 3).
/// Conmuta entre Recargas monetarias o Paquetes de megas.
/// Valida que el monto o paquete sea válido antes de habilitar el avance al comprobante.
class NuevaRecargaScreen extends StatefulWidget {
  const NuevaRecargaScreen({super.key});

  @override
  State<NuevaRecargaScreen> createState() => _NuevaRecargaScreenState();
}

class _NuevaRecargaScreenState extends State<NuevaRecargaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valorController;
  Paquete? _paqueteLocal;
  late TipoRecarga _tipoLocal;

  @override
  void initState() {
    super.initState();
    final controller = context.read<RecargaController>();
    _tipoLocal = controller.tipo;
    _paqueteLocal = controller.paqueteSeleccionado;
    _valorController = TextEditingController(
      text: controller.valorRecarga > 0
          ? controller.valorRecarga.toStringAsFixed(2)
          : '5.00',
    );
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _continuar() {
    final controller = context.read<RecargaController>();

    if (_tipoLocal == TipoRecarga.recarga) {
      if (!_formKey.currentState!.validate()) return;
      final limpio = _valorController.text.trim().replaceAll(',', '.');
      final double valor = double.tryParse(limpio) ?? 0.0;
      if (valor < 1.0) return;

      controller.setValorRecarga(valor);
    } else {
      if (_paqueteLocal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona un combo para continuar.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      controller.setPaquete(_paqueteLocal!);
    }

    // Navegar al Paso 4: Comprobante y Liquidación
    Navigator.pushNamed(context, AppRoutes.comprobante);
  }

  @override
  Widget build(BuildContext context) {
    final recargaController = context.watch<RecargaController>();
    final operadora = recargaController.operadora;

    // Validación defensiva segura: si no hay operadora, renderizar vista de retorno segura sin postFrameCallback
    if (operadora == null) {
      return Scaffold(
        backgroundColor: AppColors.fondo,
        appBar: AppBar(
          title: const Text('Paso 3 de 4'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.operadoras);
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
                    Icons.cell_tower_rounded,
                    size: 64,
                    color: AppColors.textoSecundario,
                  ),
                  const SizedBox(height: 16),
                  const AppTitle(
                    text: 'Operadora no seleccionada',
                    size: AppTitleSize.medio,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Debes elegir primero una operadora móvil para ver los combos disponibles.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Elegir Operadora',
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.operadoras);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Obtener catálogo de paquetes de la operadora
    final paquetesDisponibles =
        DatosSimulados.obtenerPaquetesPorOperadora(operadora.id);

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Paso 3 de 4'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.operadoras);
            }
          },
          tooltip: 'Regresar a la selección de operadoras',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SeleccionMontoSection(
                numeroTelefono: recargaController.numeroTelefono,
                operadora: operadora,
                tipoSeleccionado: _tipoLocal,
                onTipoChanged: (nuevoTipo) {
                  setState(() {
                    _tipoLocal = nuevoTipo;
                    recargaController.setTipoRecarga(nuevoTipo);
                  });
                },
                formKey: _formKey,
                valorController: _valorController,
                paquetes: paquetesDisponibles,
                paqueteSeleccionado: _paqueteLocal,
                onPaqueteSeleccionado: (paquete) {
                  setState(() {
                    _paqueteLocal = paquete;
                    recargaController.setPaquete(paquete);
                  });
                },
                onValorRapidoSeleccionado: (monto) {
                  setState(() {
                    _valorController.text = monto.toStringAsFixed(2);
                    recargaController.setValorRecarga(monto);
                  });
                },
                onContinuar: _continuar,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
