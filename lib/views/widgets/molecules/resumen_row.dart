import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../atoms/app_label.dart';

/// Molécula: Fila de detalle financiero con desglose etiqueta–valor.
/// Utilizada en la sección "Resumen" del Mockup 4 (Comprobante):
/// Valor del combo/recarga, Comisión y Total a liquidar.
/// Reutiliza exclusivamente el átomo [AppLabel].
class ResumenRow extends StatelessWidget {
  /// Nombre del concepto o rubro (ej. "Valor recarga", "Comisión (3%)", "Total a Pagar").
  final String etiqueta;

  /// Monto o cifra formateada (ej. "$10.00", "$0.30", "$10.30").
  final String valor;

  /// Si es true, aplica mayor tamaño, grosor e impacto tipográfico (ideal para el Total final).
  final bool esDestacado;

  /// Color personalizado opcional para la cifra.
  final Color? colorValor;

  /// Texto aclaratorio breve debajo de la etiqueta (ej. "Acreditación directa").
  final String? subtitulo;

  const ResumenRow({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.esDestacado = false,
    this.colorValor,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: esDestacado ? 8.0 : 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Etiqueta del rubro con subtítulo opcional
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLabel(
                  text: etiqueta,
                  variant: esDestacado
                      ? AppLabelVariant.etiqueta
                      : AppLabelVariant.cuerpo,
                  fontWeight: esDestacado ? FontWeight.w700 : FontWeight.w500,
                  color: esDestacado
                      ? AppColors.textoPrincipal
                      : AppColors.textoSecundario,
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 2),
                  AppLabel(
                    text: subtitulo!,
                    variant: AppLabelVariant.pequena,
                    color: AppColors.textoPista,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Cifra monetaria liquidada
          AppLabel(
            text: valor,
            variant: esDestacado
                ? AppLabelVariant.monto
                : AppLabelVariant.etiqueta,
            fontWeight: esDestacado ? FontWeight.w800 : FontWeight.w700,
            color: colorValor ??
                (esDestacado ? AppColors.primario : AppColors.textoPrincipal),
          ),
        ],
      ),
    );
  }
}

