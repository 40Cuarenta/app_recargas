import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../core/utils/formateadores.dart';
import '../../../models/operadora.dart';
import '../atoms/app_label.dart';
import '../atoms/app_selector.dart';

/// Molécula: selección de operadora y explicación de su comisión base.
class SelectorOperadora extends StatelessWidget {
  final List<Operadora> operadoras;
  final Operadora? seleccionada;
  final ValueChanged<Operadora?> alCambiar;

  const SelectorOperadora({
    super.key,
    required this.operadoras,
    required this.seleccionada,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelector<Operadora>(
          etiqueta: 'Operadora',
          valor: seleccionada,
          opciones: operadoras
              .map(
                (operadora) => DropdownMenuItem(
                  value: operadora,
                  child: AppLabel(text: operadora.nombre),
                ),
              )
              .toList(),
          alCambiar: alCambiar,
          validar: Validators.validarOperadora,
        ),
        if (seleccionada != null) ...[
          const SizedBox(height: 8),
          AppLabel(
            text:
                'Comisión base: ${formatearPorcentaje(seleccionada!.porcentajeComision)} %. '
                'Desde \$10 baja un punto si supera el 3 %.',
            variant: AppLabelVariant.pequena,
          ),
        ],
      ],
    );
  }
}
