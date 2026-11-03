import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/organisms/numero_recarga_form.dart';

/// Pantalla 3: Ingreso de Número a Recargar (Paso 1 del flujo - Mockup 2).
/// Solicita y valida el número de teléfono móvil receptor (10 dígitos, prefijo 09).
/// Si el usuario cancela o regresa a la pantalla principal, reinicia el flujo.
class NumeroRecargaScreen extends StatefulWidget {
  const NumeroRecargaScreen({super.key});

  @override
  State<NumeroRecargaScreen> createState() => _NumeroRecargaScreenState();
}

class _NumeroRecargaScreenState extends State<NumeroRecargaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    final recargaController = context.read<RecargaController>();
    _telefonoController = TextEditingController(
      text: recargaController.numeroTelefono.isNotEmpty
          ? recargaController.numeroTelefono
          : '0991234567',
    );
  }

  @override
  void dispose() {
    _telefonoController.dispose();
    super.dispose();
  }

  void _regresar() {
    // Si el usuario sale a mitad del flujo en el Paso 1, reiniciar el estado
    context.read<RecargaController>().reiniciar();

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

  void _continuar() {
    if (!_formKey.currentState!.validate()) return;

    // Guardar número en el controlador central
    final recargaController = context.read<RecargaController>();
    recargaController.setNumeroTelefono(_telefonoController.text);
    recargaController.setPasoActual(2);

    // Navegar al Paso 2: Selección de Operadora
    Navigator.pushNamed(context, AppRoutes.operadoras);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _regresar();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.fondo,
        appBar: AppBar(
          title: const Text('Paso 1 de 4'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _regresar,
            tooltip: 'Regresar a la pantalla principal',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 28.0,
                    ),
                    child: NumeroRecargaForm(
                      formKey: _formKey,
                      telefonoController: _telefonoController,
                      onContinuar: _continuar,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
