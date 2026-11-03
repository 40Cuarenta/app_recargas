import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../atoms/app_label.dart';
import '../atoms/app_logo.dart';
import '../atoms/app_title.dart';

/// Molécula: Cabecera de usuario y marca.
/// Utilizada en la parte superior de la Pantalla Principal (Mockup 1):
/// Isotipo corporativo + "Bienvenido," + Nombre del usuario activo.
/// Reutiliza exclusivamente los átomos [AppLogo], [AppTitle] y [AppLabel].
class UserHeader extends StatelessWidget {
  /// Nombre del usuario autenticado en la sesión.
  final String nombreUsuario;

  /// Leyenda o rol del usuario (ej. "Punto de Venta Autorizado").
  final String? subtitulo;

  /// Tamaño exterior del logo / avatar (por defecto 48.0 para barras superiores).
  final double logoSize;

  /// Elemento de acción opcional en la esquina derecha (ej. botón de cierre o notificaciones).
  final Widget? trailing;

  const UserHeader({
    super.key,
    required this.nombreUsuario,
    this.subtitulo = 'Punto de Venta Autorizado',
    this.logoSize = 48.0,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logotipo / Isotipo de marca
        AppLogo(
          size: logoSize,
          withShadow: false,
          borderRadius: 14.0,
        ),
        const SizedBox(width: 14),

        // Saludo y nombre de usuario
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLabel(
                text: 'Bienvenido,',
                variant: AppLabelVariant.pequena,
                color: AppColors.textoSecundario,
              ),
              const SizedBox(height: 1),
              AppTitle(
                text: nombreUsuario,
                size: AppTitleSize.pequeno,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 1),
                AppLabel(
                  text: subtitulo!,
                  variant: AppLabelVariant.pequena,
                  color: AppColors.textoPista,
                ),
              ],
            ],
          ),
        ),

        ?trailing,
      ],
    );
  }
}

