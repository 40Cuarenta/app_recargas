import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Átomo: Componente interactivo de selección tipo chip / ficha táctil.
/// Permite al usuario conmutar entre opciones mutuamente excluyentes (modalidad de recarga,
/// montos predeterminados, métodos de pago u operadoras).
class AppChipOption extends StatelessWidget {
  /// Texto principal de la opción (ej. "Recargas", "Paquetes", "$5.00").
  final String label;

  /// Indica si la opción se encuentra actualmente seleccionada.
  final bool isSelected;

  /// Callback que se activa al tocar la opción.
  final VoidCallback onTap;

  /// Ícono opcional posicionado antes del texto.
  final IconData? icon;

  /// Texto secundario breve debajo del título (ej. "Vigencia 1 día").
  final String? subtitle;

  /// Color de acento para el estado seleccionado (por defecto [AppColors.primario]).
  final Color? selectedColor;

  /// Relleno interno del chip.
  final EdgeInsetsGeometry? padding;

  /// Ancho personalizado opcional.
  final double? width;

  const AppChipOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.selectedColor,
    this.padding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorActivo = selectedColor ?? AppColors.primario;

    final Color colorFondo = isSelected
        ? colorActivo.withValues(alpha: 0.10)
        : AppColors.superficie;

    final Color colorBorde = isSelected
        ? colorActivo
        : AppColors.borde;

    final Color colorTexto = isSelected
        ? colorActivo
        : AppColors.textoPrincipal;

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorBorde,
                width: isSelected ? 1.8 : 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: colorTexto,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: subtitle != null
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.etiquetaGrande.copyWith(
                          color: colorTexto,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.cuerpoPequeno.copyWith(
                            color: isSelected
                                ? colorActivo.withValues(alpha: 0.85)
                                : AppColors.textoSecundario,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

