import 'package:flutter/material.dart';
import '../../../models/recarga.dart';
import '../atoms/app_chip_option.dart';

/// Molécula: Selector tipo ficha segmentada para conmutar entre "Recargas" y "Paquetes".
/// Implementa la estructura del Mockup 3 ("Elige como quieres recargar").
/// Reutiliza exclusivamente el átomo [AppChipOption].
class SelectorTipoRecarga extends StatelessWidget {
  /// Tipo de operación actualmente activa ([TipoRecarga.recarga] o [TipoRecarga.paquete]).
  final TipoRecarga tipoSeleccionado;

  /// Callback emitido cuando el usuario conmuta la opción.
  final ValueChanged<TipoRecarga> onTipoChanged;

  const SelectorTipoRecarga({
    super.key,
    required this.tipoSeleccionado,
    required this.onTipoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Opción: Recargas de saldo monetario
        Expanded(
          child: AppChipOption(
            label: 'Recargas',
            icon: Icons.payments_rounded,
            isSelected: tipoSeleccionado == TipoRecarga.recarga,
            onTap: () => onTipoChanged(TipoRecarga.recarga),
          ),
        ),
        const SizedBox(width: 12),

        // Opción: Paquetes y combos de datos
        Expanded(
          child: AppChipOption(
            label: 'Paquetes',
            icon: Icons.inventory_2_rounded,
            isSelected: tipoSeleccionado == TipoRecarga.paquete,
            onTap: () => onTipoChanged(TipoRecarga.paquete),
          ),
        ),
      ],
    );
  }
}

