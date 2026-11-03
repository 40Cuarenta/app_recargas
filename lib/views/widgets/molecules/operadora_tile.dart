import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/operadora.dart';
import '../atoms/app_icon_badge.dart';
import '../atoms/app_label.dart';
import '../atoms/app_title.dart';

/// Molécula: Ficha táctil representativa de una operadora de telecomunicaciones.
/// Utilizada en la cuadrícula de selección del Mockup 2 (Tigo, Movistar, CNT, Tuenti, etc.).
/// Reutiliza los átomos [AppIconBadge], [AppTitle] y [AppLabel].
class OperadoraTile extends StatelessWidget {
  /// Operadora representada en esta ficha.
  final Operadora operadora;

  /// Indica si la operadora está actualmente seleccionada por el usuario.
  final bool isSelected;

  /// Callback ejecutado al tocar la ficha.
  final VoidCallback onTap;

  const OperadoraTile({
    super.key,
    required this.operadora,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int porcentajeInt = (operadora.porcentajeComision * 100).round();
    final Color colorActivo = operadora.colorCorporativo;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected
                ? colorActivo.withValues(alpha: 0.08)
                : AppColors.superficie,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colorActivo : AppColors.borde,
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorActivo.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge de ícono con el color de la operadora
              AppIconBadge(
                icon: operadora.icono,
                size: 52,
                iconSize: 28,
                iconColor: colorActivo,
                backgroundColor: colorActivo.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 12),

              // Nombre de la operadora
              AppTitle(
                text: operadora.nombre,
                size: AppTitleSize.pequeno,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Indicador de comisión comercial
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorActivo.withValues(alpha: 0.14)
                      : AppColors.superficieVariante,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppLabel(
                  text: 'Comisión $porcentajeInt%',
                  variant: AppLabelVariant.pequena,
                  color: isSelected ? colorActivo : AppColors.textoSecundario,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

