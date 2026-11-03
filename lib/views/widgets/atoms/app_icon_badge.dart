import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Átomo: Contenedor insignia redondeado con un ícono central.
/// Utilizado para destacar operadoras telefónicas, avatares de usuario,
/// categorías de recarga y estados de éxito en comprobantes.
class AppIconBadge extends StatelessWidget {
  /// Ícono a renderizar.
  final IconData icon;

  /// Dimensión externa (ancho y alto) del contenedor.
  final double size;

  /// Tamaño específico del glifo del ícono.
  final double iconSize;

  /// Color de fondo del contenedor (por defecto usa el contenedor primario del tema).
  final Color? backgroundColor;

  /// Color del ícono (por defecto usa el color primario corporativo).
  final Color? iconColor;

  /// Radio de redondeo de las esquinas del contenedor.
  final double borderRadius;

  /// Borde perimetral opcional para mayor definición sobre fondos claros.
  final BoxBorder? border;

  const AppIconBadge({
    super.key,
    required this.icon,
    this.size = 46.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 14.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primarioClaro,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.primario,
        ),
      ),
    );
  }
}

