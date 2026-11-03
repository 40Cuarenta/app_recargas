import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Átomo: Contenedor insignia / logotipo configurable de la aplicación.
/// Muestra un isotipo estilizado de conectividad y telefonía con bordes suaves,
/// gradiente corporativo y dimensiones adaptables a pantallas de login o barras superiores.
class AppLogo extends StatelessWidget {
  /// Dimensión cuadrada (ancho y alto) del contenedor del logo.
  final double size;

  /// Ícono central que representa la identidad de telecomunicaciones.
  final IconData icon;

  /// Indica si se debe mostrar una sombra suave detrás del logo.
  final bool withShadow;

  /// Radio de curvatura de las esquinas del isotipo.
  final double? borderRadius;

  const AppLogo({
    super.key,
    this.size = 80.0,
    this.icon = Icons.bolt_rounded,
    this.withShadow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final double radio = borderRadius ?? (size * 0.28);
    final double tamanoIcono = size * 0.52;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radio),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primario,
            AppColors.primarioOscuro,
          ],
        ),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: AppColors.primario.withValues(alpha: 0.25),
                  blurRadius: size * 0.25,
                  offset: Offset(0, size * 0.1),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          icon,
          size: tamanoIcono,
          color: AppColors.textoBlanco,
        ),
      ),
    );
  }
}

