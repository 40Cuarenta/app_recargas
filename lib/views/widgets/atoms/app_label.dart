import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Variantes semánticas para etiquetas de texto del sistema.
enum AppLabelVariant {
  /// Subtítulos descriptivos o textos guía bajo títulos.
  subtitulo,

  /// Cuerpo estándar de lectura y explicaciones.
  cuerpo,

  /// Etiqueta destacada para nombres de campos y encabezados de items.
  etiqueta,

  /// Etiqueta compacta para notas secundarias, vigencias y badges.
  pequena,

  /// Cifra numérica de gran tamaño para saldos y totales monetarios.
  monto,
}

/// Átomo: Texto semántico secundario (etiquetas, descripciones, cifras) vinculado al tema.
class AppLabel extends StatelessWidget {
  /// Cadena de texto a mostrar.
  final String text;

  /// Variante semántica que aplica la tipografía adecuada.
  final AppLabelVariant variant;

  /// Alineación horizontal.
  final TextAlign? textAlign;

  /// Color sustituto opcional.
  final Color? color;

  /// Grosor de fuente personalizado opcional.
  final FontWeight? fontWeight;

  /// Cantidad máxima de líneas permitidas.
  final int? maxLines;

  /// Modo de truncamiento.
  final TextOverflow? overflow;

  const AppLabel({
    super.key,
    required this.text,
    this.variant = AppLabelVariant.cuerpo,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = switch (variant) {
      AppLabelVariant.subtitulo => AppTextStyles.subtitulo,
      AppLabelVariant.cuerpo => AppTextStyles.cuerpoMedio,
      AppLabelVariant.etiqueta => AppTextStyles.etiquetaGrande,
      AppLabelVariant.pequena => AppTextStyles.etiquetaPequena,
      AppLabelVariant.monto => AppTextStyles.montoDestacado,
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

