import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/paquete.dart';
import '../atoms/app_icon_badge.dart';
import '../atoms/app_label.dart';

/// Molécula: Tarjeta interactiva para la selección de un paquete o combo telefónico.
/// Utilizada en el catálogo de paquetes del Mockup 3.
/// Reutiliza los átomos [AppLabel], [AppIconBadge] y la estética de tarjetas del tema.
class PaqueteCard extends StatelessWidget {
  /// Paquete de datos y telefonía que representa esta tarjeta.
  final Paquete paquete;

  /// Indica si este paquete se encuentra actualmente seleccionado.
  final bool isSelected;

  /// Callback ejecutado al pulsar la tarjeta.
  final VoidCallback onTap;

  const PaqueteCard({
    super.key,
    required this.paquete,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String precioFormateado = '\$${paquete.precio.toStringAsFixed(2)}';
    final String datosFormateados = '${paquete.datos.toStringAsFixed(paquete.datos.truncateToDouble() == paquete.datos ? 0 : 1)} GB';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primarioClaro.withValues(alpha: 0.35)
                : AppColors.superficie,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.primario : AppColors.borde,
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primario.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Encabezado: Precio y Badge de selección
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLabel(
                    text: precioFormateado,
                    variant: AppLabelVariant.monto,
                    color: isSelected ? AppColors.primario : AppColors.textoPrincipal,
                  ),
                  AppIconBadge(
                    icon: isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 32,
                    iconSize: 20,
                    iconColor: isSelected ? AppColors.primario : AppColors.textoPista,
                    backgroundColor: isSelected
                        ? AppColors.primarioClaro
                        : AppColors.superficieVariante,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Nombre del combo
              AppLabel(
                text: paquete.nombre,
                variant: AppLabelVariant.etiqueta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Badges de Vigencia y Gigas
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secundarioClaro,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppLabel(
                      text: datosFormateados,
                      variant: AppLabelVariant.pequena,
                      color: AppColors.secundarioOscuro,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.superficieVariante,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppLabel(
                      text: paquete.vigencia,
                      variant: AppLabelVariant.pequena,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Descripción y aplicaciones incluidas
              AppLabel(
                text: paquete.descripcion,
                variant: AppLabelVariant.cuerpo,
                color: AppColors.textoSecundario,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

