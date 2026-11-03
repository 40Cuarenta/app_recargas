import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Variantes visuales disponibles para el botón atómico de la aplicación.
enum AppButtonVariant {
  /// Botón principal para acciones de avance (Iniciar sesión, Continuar, Confirmar).
  primario,

  /// Botón con borde para acciones secundarias o de retorno (Regresar, Cancelar).
  secundario,

  /// Botón de alerta o acción destructiva (Cerrar sesión, Eliminar).
  peligro,
}

/// Átomo: Botón reutilizable con soporte de variantes, estados de carga e íconos.
/// Respeta las dimensiones y colores definidos centralizadamente en [AppTheme].
class AppButton extends StatelessWidget {
  /// Texto visible dentro del botón.
  final String text;

  /// Acción a ejecutar al presionar el botón (si es nulo o [isLoading] es true, se deshabilita).
  final VoidCallback? onPressed;

  /// Variante de diseño que define la jerarquía visual del botón.
  final AppButtonVariant variant;

  /// Si es true, reemplaza el contenido por un indicador de progreso circular.
  final bool isLoading;

  /// Ícono opcional situado a la izquierda del texto.
  final IconData? icon;

  /// Ancho personalizado. Si es nulo, se expande al ancho completo disponible.
  final double? width;

  /// Altura mínima del botón (por defecto 54.0 para óptima ergonomía táctil).
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primario,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool estaHabilitado = onPressed != null && !isLoading;

    // Resolver el estilo según la variante seleccionada
    final ButtonStyle baseStyle = switch (variant) {
      AppButtonVariant.primario => AppTheme.botonPrimario,
      AppButtonVariant.secundario => AppTheme.botonSecundario,
      AppButtonVariant.peligro => AppTheme.botonPeligro,
    };

    // Color del indicador de carga coherente con la variante
    final Color colorIndicador = switch (variant) {
      AppButtonVariant.primario => AppColors.textoBlanco,
      AppButtonVariant.secundario => AppColors.primario,
      AppButtonVariant.peligro => AppColors.peligro,
    };

    Widget contenido;
    if (isLoading) {
      contenido = SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(colorIndicador),
        ),
      );
    } else if (icon != null) {
      contenido = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      contenido = Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final Widget boton = switch (variant) {
      AppButtonVariant.primario || AppButtonVariant.peligro => ElevatedButton(
          onPressed: estaHabilitado ? onPressed : null,
          style: baseStyle,
          child: contenido,
        ),
      AppButtonVariant.secundario => OutlinedButton(
          onPressed: estaHabilitado ? onPressed : null,
          style: baseStyle,
          child: contenido,
        ),
    };

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: boton,
    );
  }
}

