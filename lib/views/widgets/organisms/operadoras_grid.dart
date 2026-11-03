import 'package:flutter/material.dart';
import '../../../models/operadora.dart';
import '../atoms/app_label.dart';
import '../atoms/app_title.dart';
import '../molecules/operadora_tile.dart';

/// Organismo: Cuadrícula interactiva de compañías operadoras de telefonía móvil.
/// Corresponde a la "Pantalla de Operadoras" (Mockup 2).
/// Agrupa y renderiza los componentes [OperadoraTile] dentro de un [GridView] adaptable.
class OperadorasGrid extends StatelessWidget {
  /// Lista de operadoras disponibles para recarga (Tigo, Movistar, CNT, Tuenti, etc.).
  final List<Operadora> operadoras;

  /// Operadora actualmente seleccionada en el flujo (puede ser null inicialmente).
  final Operadora? operadoraSeleccionada;

  /// Callback que notifica la selección de una operadora.
  final ValueChanged<Operadora> onOperadoraSeleccionada;

  const OperadorasGrid({
    super.key,
    required this.operadoras,
    required this.operadoraSeleccionada,
    required this.onOperadoraSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Título del paso
        const AppTitle(
          text: 'Elige la operadora',
          size: AppTitleSize.medio,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const AppLabel(
          text: 'Selecciona la compañía móvil a la que pertenece el número',
          variant: AppLabelVariant.subtitulo,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // GridView de fichas de operadoras
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: operadoras.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final operadora = operadoras[index];
            final bool isSelected = operadoraSeleccionada?.id == operadora.id;

            return OperadoraTile(
              operadora: operadora,
              isSelected: isSelected,
              onTap: () => onOperadoraSeleccionada(operadora),
            );
          },
        ),
      ],
    );
  }
}

