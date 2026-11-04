import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../controllers/recarga_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../data/datos_simulados.dart';
import '../../../models/recarga.dart';
import '../atoms/app_button.dart';
import '../atoms/app_chip_option.dart';
import '../atoms/app_label.dart';
import '../atoms/app_text_field.dart';
import '../atoms/app_title.dart';
import '../molecules/metodo_pago_selector.dart';
import '../molecules/selector_operadora.dart';
import 'seleccion_monto_section.dart';

/// Organismo que reúne el destinatario, servicio y pago en un solo formulario.
class FormularioRecarga extends StatefulWidget {
  final double saldoDisponible;

  const FormularioRecarga({super.key, required this.saldoDisponible});

  @override
  State<FormularioRecarga> createState() => _EstadoFormularioRecarga();
}

class _EstadoFormularioRecarga extends State<FormularioRecarga> {
  final _formulario = GlobalKey<FormState>();
  final _telefono = TextEditingController(text: '0991234567');
  final _monto = TextEditingController(text: '5.00');

  @override
  void initState() {
    super.initState();
    _telefono.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

  @override
  void dispose() {
    _telefono.removeListener(_actualizar);
    _telefono.dispose();
    _monto.dispose();
    super.dispose();
  }

  void _limpiar() {
    _formulario.currentState!.reset();
    _telefono.clear();
    _monto.clear();
    context.read<RecargaController>().reiniciar();
    FocusScope.of(context).unfocus();
  }

  Future<void> _revisar() async {
    if (!_formulario.currentState!.validate()) return;
    final controlador = context.read<RecargaController>();
    if (controlador.tipo == TipoRecarga.paquete &&
        controlador.paqueteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un paquete para continuar.')),
      );
      return;
    }
    controlador.setNumeroTelefono(_telefono.text);
    if (controlador.tipo == TipoRecarga.recarga) {
      controlador.setValorRecarga(
        double.parse(_monto.text.trim().replaceAll(',', '.')),
      );
    }
    FocusScope.of(context).unfocus();
    await Navigator.pushNamed(context, AppRoutes.comprobante);
    if (!mounted) return;
    // Al volver antes de pagar se conservan los datos; después de pagar se limpian.
    if (controlador.ultimoComprobante != null) _limpiar();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = context.watch<RecargaController>();
    final operadora = controlador.operadora;
    return Form(
      key: _formulario,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppTitle(text: 'Nueva recarga'),
          const SizedBox(height: 16),
          AppTextField(
            controller: _telefono,
            label: 'Número celular (Ecuador)',
            hintText: '09xxxxxxxx',
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            validator: Validators.validarTelefono,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['0991234567', '0987654321', '0961122334']
                .map(
                  (numero) => AppChipOption(
                    label: numero,
                    isSelected: _telefono.text == numero,
                    onTap: () => _telefono.text = numero,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          SelectorOperadora(
            operadoras: DatosSimulados.operadoras,
            seleccionada: operadora,
            alCambiar: (nueva) {
              if (nueva != null) controlador.setOperadora(nueva);
            },
          ),
          const SizedBox(height: 24),
          if (operadora != null)
            SeleccionMontoSection(
              numeroTelefono: _telefono.text,
              operadora: operadora,
              tipoSeleccionado: controlador.tipo,
              onTipoChanged: controlador.setTipoRecarga,
              valorController: _monto,
              paquetes: DatosSimulados.obtenerPaquetesPorOperadora(
                operadora.id,
              ),
              paqueteSeleccionado: controlador.paqueteSeleccionado,
              onPaqueteSeleccionado: controlador.setPaquete,
              onValorRapidoSeleccionado: (monto) {
                setState(() => _monto.text = monto.toStringAsFixed(2));
                controlador.setValorRecarga(monto);
              },
            ),
          const SizedBox(height: 24),
          const AppTitle(text: 'Método de pago', size: AppTitleSize.pequeno),
          const SizedBox(height: 12),
          MetodoPagoSelector(
            metodoSeleccionado: controlador.metodoPago,
            onMetodoChanged: controlador.setMetodoPago,
            saldoDisponible: widget.saldoDisponible,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'REVISAR RECARGA',
            icon: Icons.receipt_long_rounded,
            onPressed: _revisar,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'LIMPIAR RECARGA',
            variant: AppButtonVariant.secundario,
            onPressed: _limpiar,
          ),
          const SizedBox(height: 16),
          const AppLabel(
            text: 'Simulación educativa: no se realizan pagos ni recargas reales.',
            variant: AppLabelVariant.pequena,
          ),
        ],
      ),
    );
  }
}
