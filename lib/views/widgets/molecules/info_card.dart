import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../atoms/app_icon_badge.dart';
import '../atoms/app_title.dart';

/// Molécula: Tarjeta contenedora de información estructurada.
/// Diseñada para las secciones principales del Mockup 1 ("Mi Combo" y "Mi saldo actual").
/// Reutiliza los átomos [AppTitle], [AppIconBadge] y la estética de tarjetas del tema.
class InfoCard extends StatelessWidget {
  /// Título de la sección o tarjeta (ej. "Mi saldo actual:", "Mi Combo").
  final String titulo;

  /// Ícono representativo en la esquina superior izquierda.
  final IconData? icono;

  /// Color del ícono.
  final Color? colorIcono;

  /// Color de fondo del badge del ícono.
  final Color? colorFondoIcono;

  /// Contenido principal alojado dentro de la tarjeta (texto, montos, filas).
  final Widget contenido;

  /// Widget complementario opcional en la esquina derecha del encabezado (ej. chip de estado).
  final Widget? trailing;

  /// Acción táctil opcional al pulsar la tarjeta completa.
  final VoidCallback? onTap;

  /// Relleno interno personalizado.
  final EdgeInsetsGeometry padding;

  const InfoCard({
    super.key,
    required this.titulo,
    required this.contenido,
    this.icono,
    this.colorIcono,
    this.colorFondoIcono,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    final Widget cuerpo = Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado de la tarjeta
            Row(
              children: [
                if (icono != null) ...[
                  AppIconBadge(
                    icon: icono!,
                    size: 42,
                    iconSize: 22,
                    iconColor: colorIcono ?? AppColors.primario,
                    backgroundColor: colorFondoIcono ?? AppColors.primarioClaro,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: AppTitle(
                    text: titulo,
                    size: AppTitleSize.pequeno,
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 14),

            // Contenido dinámico
            contenido,
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: cuerpo,
      );
    }

    return cuerpo;
  }
}

