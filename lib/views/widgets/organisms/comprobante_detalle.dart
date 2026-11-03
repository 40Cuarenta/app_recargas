import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/operadora.dart';
import '../../../models/paquete.dart';
import '../../../models/recarga.dart';
import '../atoms/app_button.dart';
import '../atoms/app_icon_badge.dart';
import '../atoms/app_label.dart';
import '../atoms/app_title.dart';
import '../molecules/metodo_pago_selector.dart';
import '../molecules/resumen_row.dart';

/// Organismo: Detalle del comprobante previo a la confirmación de la transacción.
/// Corresponde a la "Pantalla de Comprobante" (Mockup 4):
/// 1. Número y Operadora destino.
/// 2. Detalle completo del combo o recarga (vigencia, gigas, aplicaciones).
/// 3. Selector de Método de pago ("Débito de cuenta" vs "Tarjeta").
/// 4. Resumen financiero (Subtotal, Comisión por operadora, Total y Ganancia local).
/// 5. Botón de confirmación con el valor total a liquidar.
class ComprobanteDetalle extends StatelessWidget {
  /// Número celular al que se acreditará el saldo o combo.
  final String numeroTelefono;

  /// Compañía operadora seleccionada.
  final Operadora operadora;

  /// Tipo de operación efectuada ([TipoRecarga.recarga] o [TipoRecarga.paquete]).
  final TipoRecarga tipo;

  /// Monto facial o base de la recarga.
  final double valorBase;

  /// Paquete o combo seleccionado (si el tipo es paquete).
  final Paquete? paquete;

  /// Medio de pago seleccionado actualmente.
  final MetodoPago metodoPago;

  /// Callback para alternar el medio de pago.
  final ValueChanged<MetodoPago> onMetodoPagoChanged;

  /// Saldo disponible en la cuenta del comerciante (para validar débito).
  final double saldoDisponible;

  /// Comisión calculada en dólares.
  final double comision;

  /// Porcentaje de comisión efectivo aplicado (ej. 0.03 o 0.02).
  final double porcentajeComision;

  /// Total liquidado (valorBase + comision).
  final double total;

  /// Utilidad o ganancia que percibirá el punto de venta.
  final double ganancia;

  /// Callback emitido para procesar y confirmar el pago.
  final VoidCallback onConfirmarPago;

  /// Estado de procesamiento del botón de pago.
  final bool isProcessing;

  /// Mensaje de error reactivo (ej. saldo insuficiente en cuenta).
  final String? errorMessage;

  const ComprobanteDetalle({
    super.key,
    required this.numeroTelefono,
    required this.operadora,
    required this.tipo,
    required this.valorBase,
    this.paquete,
    required this.metodoPago,
    required this.onMetodoPagoChanged,
    required this.saldoDisponible,
    required this.comision,
    required this.porcentajeComision,
    required this.total,
    required this.ganancia,
    required this.onConfirmarPago,
    this.isProcessing = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final int pctComisionEntero = (porcentajeComision * 100).round();
    final int pctGananciaEntero = (operadora.porcentajeGanancia * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Número y Operadora
        const AppTitle(
          text: 'NUMERO DE RECARGA',
          size: AppTitleSize.pequeno,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AppIconBadge(
                  icon: operadora.icono,
                  size: 44,
                  iconSize: 22,
                  iconColor: operadora.colorCorporativo,
                  backgroundColor: operadora.colorCorporativo.withValues(alpha: 0.12),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabel(
                        text: operadora.nombre,
                        variant: AppLabelVariant.pequena,
                        color: operadora.colorCorporativo,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 2),
                      AppTitle(
                        text: numeroTelefono,
                        size: AppTitleSize.pequeno,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Detalle del Combo o Recarga a realizar
        const AppTitle(
          text: 'COMBO/RECARGA A REALIZAR',
          size: AppTitleSize.pequeno,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppLabel(
                        text: tipo == TipoRecarga.paquete
                            ? (paquete?.nombre ?? 'Combo Seleccionado')
                            : 'Recarga Directa de Saldo',
                        variant: AppLabelVariant.etiqueta,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppLabel(
                      text: '\$${valorBase.toStringAsFixed(2)}',
                      variant: AppLabelVariant.etiqueta,
                      color: AppColors.primario,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tipo == TipoRecarga.paquete && paquete != null) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secundarioClaro,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppLabel(
                          text: '${paquete!.datos.toStringAsFixed(0)} GB',
                          variant: AppLabelVariant.pequena,
                          color: AppColors.secundarioOscuro,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppLabel(
                        text: 'Vigencia: ${paquete!.vigencia}',
                        variant: AppLabelVariant.pequena,
                        color: AppColors.textoSecundario,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AppLabel(
                    text: paquete!.descripcion,
                    variant: AppLabelVariant.cuerpo,
                    color: AppColors.textoSecundario,
                  ),
                ] else ...[
                  const AppLabel(
                    text: 'Acreditación instantánea de saldo monetario para llamadas, SMS o paquetes a demanda.',
                    variant: AppLabelVariant.cuerpo,
                    color: AppColors.textoSecundario,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Método de pago
        const AppTitle(
          text: 'Método de pago',
          size: AppTitleSize.pequeno,
        ),
        const SizedBox(height: 8),
        MetodoPagoSelector(
          metodoSeleccionado: metodoPago,
          onMetodoChanged: onMetodoPagoChanged,
          saldoDisponible: saldoDisponible,
        ),
        const SizedBox(height: 20),

        // 4. Resumen financiero
        const AppTitle(
          text: 'Resumen',
          size: AppTitleSize.pequeno,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ResumenRow(
                  etiqueta: 'Valor combo/recarga',
                  valor: '\$${valorBase.toStringAsFixed(2)}',
                ),
                ResumenRow(
                  etiqueta: 'Comisión ($pctComisionEntero% ${operadora.nombre})',
                  valor: '\$${comision.toStringAsFixed(2)}',
                  subtitulo: valorBase >= 10.0
                      ? 'Descuento especial (-1% por monto >= \$10)'
                      : null,
                ),
                const Divider(height: 20),
                ResumenRow(
                  etiqueta: 'Total a Pagar',
                  valor: '\$${total.toStringAsFixed(2)}',
                  esDestacado: true,
                ),
                const SizedBox(height: 4),
                // Indicador de ganancia para el negocio
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.acentoClaro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: AppColors.acento,
                          ),
                          const SizedBox(width: 6),
                          AppLabel(
                            text: 'Ganancia estimada ($pctGananciaEntero%):',
                            variant: AppLabelVariant.pequena,
                            color: AppColors.acentoOscuro,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      AppLabel(
                        text: '+\$${ganancia.toStringAsFixed(2)}',
                        variant: AppLabelVariant.pequena,
                        color: AppColors.acentoOscuro,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Mensaje de alerta reactiva si no tiene saldo
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorFondo,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppLabel(
                    text: errorMessage!,
                    variant: AppLabelVariant.pequena,
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 28),

        // 5. Botón de Confirmación
        AppButton(
          text: 'Total a Pagar (\$${total.toStringAsFixed(2)})',
          icon: Icons.check_circle_outline_rounded,
          isLoading: isProcessing,
          onPressed: onConfirmarPago,
        ),
      ],
    );
  }
}

