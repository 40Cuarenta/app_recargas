import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Escalas tipográficas disponibles para los títulos atómicos.
enum AppTitleSize {
  /// Título de gran impacto visual (pantallas principales, login, bienvenida).
  grande,

  /// Título de tamaño intermedio (AppBar, secciones, encabezados de tarjetas).
  medio,

  /// Título compacto (nombres de paquetes, subsecciones).
  pequeno,
}

/// Átomo: Texto de encabezado y titulación que utiliza los estilos del tema corporativo.
class AppTitle extends StatelessWidget {
  /// Contenido textual a renderizar.
  final String text;

  /// Nivel jerárquico del título.
  final AppTitleSize size;

  /// Alineación horizontal del texto.
  final TextAlign? textAlign;

  /// Color personalizado (si es nulo, toma el [AppColors.textoPrincipal] del tema).
  final Color? color;

  /// Cantidad máxima de líneas antes de truncar.
  final int? maxLines;

  /// Modo de desbordamiento (ej. TextOverflow.ellipsis).
  final TextOverflow? overflow;

  const AppTitle({
    super.key,
    required this.text,
    this.size = AppTitleSize.medio,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = switch (size) {
      AppTitleSize.grande => AppTextStyles.tituloGrande,
      AppTitleSize.medio => AppTextStyles.tituloMedio,
      AppTitleSize.pequeno => AppTextStyles.tituloPequeno,
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
        color: color ?? AppColors.textoPrincipal,
      ),
    );
  }
}

