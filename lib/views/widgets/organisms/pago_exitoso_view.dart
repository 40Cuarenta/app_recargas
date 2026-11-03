import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/recarga.dart';
import '../atoms/app_button.dart';
import '../atoms/app_label.dart';
import '../atoms/app_title.dart';
import '../molecules/resumen_row.dart';

/// Organismo: Vista animada de confirmación y comprobante final de pago exitoso.
/// Corresponde a la "Pantalla de Pago Exitoso" (Mockup 4).
/// Incluye animación de checkmark y pulsación concéntrica con [TweenAnimationBuilder],
/// sin requerir librerías externas.
class PagoExitosoView extends StatelessWidget {
  /// Comprobante inmutable de la recarga completada.
  final Recarga recarga;

  /// Callback para limpiar el stack de navegación y regresar al menú principal.
  final VoidCallback onVolverPrincipal;

  const PagoExitosoView({
    super.key,
    required this.recarga,
    required this.onVolverPrincipal,
  });

  /// Formatea la fecha y hora sin dependencias externas.
  String _formatearFecha(DateTime dt) {
    final dia = dt.day.toString().padLeft(2, '0');
    final mes = dt.month.toString().padLeft(2, '0');
    final anio = dt.year;
    final hora = dt.hour.toString().padLeft(2, '0');
    final minuto = dt.minute.toString().padLeft(2, '0');
    final segundo = dt.second.toString().padLeft(2, '0');
    return '$dia/$mes/$anio • $hora:$minuto:$segundo';
  }

  @override
  Widget build(BuildContext context) {
    final String fechaStr = _formatearFecha(recarga.fecha);
    final String metodoStr = recarga.metodoPago == MetodoPago.debitoCuenta
        ? 'Débito de cuenta'
        : 'Tarjeta bancaria';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),

        // 1. Título de Confirmación
        const AppTitle(
          text: 'Confirmación de Pago',
          size: AppTitleSize.grande,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const AppLabel(
          text: '¡La recarga ha sido acreditada exitosamente!',
          variant: AppLabelVariant.subtitulo,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // 2. Animación de Éxito (TweenAnimationBuilder nativo sin librerías externas)
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, valor, child) {
              return Transform.scale(
                scale: valor,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.exitoFondo,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.exito.withValues(alpha: 0.25 * valor),
                        blurRadius: 24 * valor,
                        spreadRadius: 6 * valor,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.exito,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.textoBlanco,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 36),

        // 3. Tarjeta de Comprobante y Resumen de Transacción
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLabel(
                      text: 'COMPROBANTE ELECTRÓNICO',
                      variant: AppLabelVariant.pequena,
                      color: AppColors.textoPista,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.exitoFondo,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const AppLabel(
                        text: 'APROBADA',
                        variant: AppLabelVariant.pequena,
                        color: AppColors.exito,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ResumenRow(
                  etiqueta: 'Código de Autorización',
                  valor: recarga.idTransaccion,
                ),
                ResumenRow(
                  etiqueta: 'Fecha y Hora',
                  valor: fechaStr,
                ),
                ResumenRow(
                  etiqueta: 'Número Celular',
                  valor: recarga.numeroTelefono,
                ),
                ResumenRow(
                  etiqueta: 'Operadora Móvil',
                  valor: recarga.operadora.nombre,
                ),
                ResumenRow(
                  etiqueta: 'Servicio Contratado',
                  valor: recarga.tipo == TipoRecarga.paquete
                      ? (recarga.paquete?.nombre ?? 'Combo')
                      : 'Recarga Directa',
                ),
                ResumenRow(
                  etiqueta: 'Método de Pago',
                  valor: metodoStr,
                ),
                const Divider(height: 24),
                ResumenRow(
                  etiqueta: 'Total Cobrado al Cliente',
                  valor: '\$${recarga.total.toStringAsFixed(2)}',
                  esDestacado: true,
                ),
                const SizedBox(height: 6),
                ResumenRow(
                  etiqueta: 'Ganancia Acreditada al Local',
                  valor: '+\$${recarga.ganancia.toStringAsFixed(2)}',
                  colorValor: AppColors.exitoOscuro,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 4. Botón de retorno al inicio
        AppButton(
          text: 'VOLVER A PANTALLA PRINCIPAL',
          icon: Icons.home_rounded,
          onPressed: onVolverPrincipal,
        ),
      ],
    );
  }
}

