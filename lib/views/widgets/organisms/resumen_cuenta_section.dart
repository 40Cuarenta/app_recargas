import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/usuario.dart';
import '../atoms/app_button.dart';
import '../atoms/app_label.dart';
import '../molecules/info_card.dart';

/// Organismo: Sección central y de acciones de la Pantalla Principal (Mockup 1).
/// Agrupa:
/// 1. Tarjeta informativa "Mi Combo" (paquete promocional activo o recomendado).
/// 2. Tarjeta financiera "Mi saldo actual:" (saldo real del comercio para procesar recargas).
/// 3. Botón de acción principal: "RECARGAS Y COMBOS".
/// 4. Botón de cierre de sesión: "CERRAR SESIÓN" (estilo peligro).
class ResumenCuentaSection extends StatelessWidget {
  /// Usuario autenticado con sus saldos y combos asociados.
  final Usuario usuario;

  /// Callback emitido al presionar el botón "RECARGAS Y COMBOS".
  final VoidCallback onNuevaRecarga;

  /// Callback emitido al presionar el botón "CERRAR SESIÓN".
  final VoidCallback onCerrarSesion;

  const ResumenCuentaSection({
    super.key,
    required this.usuario,
    required this.onNuevaRecarga,
    required this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context) {
    final combo = usuario.comboActual;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Tarjeta: "Mi Combo"
        InfoCard(
          titulo: 'Mi Combo',
          icono: Icons.star_rounded,
          colorIcono: AppColors.acento,
          colorFondoIcono: AppColors.acentoClaro,
          contenido: combo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppLabel(
                            text: combo.nombre,
                            variant: AppLabelVariant.etiqueta,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AppLabel(
                          text: '\$${combo.precio.toStringAsFixed(2)}',
                          variant: AppLabelVariant.etiqueta,
                          color: AppColors.primario,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secundarioClaro,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppLabel(
                            text: '${combo.datos.toStringAsFixed(0)} GB',
                            variant: AppLabelVariant.pequena,
                            color: AppColors.secundarioOscuro,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppLabel(
                          text: 'Vigencia: ${combo.vigencia}',
                          variant: AppLabelVariant.pequena,
                          color: AppColors.textoSecundario,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AppLabel(
                      text: combo.descripcion,
                      variant: AppLabelVariant.cuerpo,
                      color: AppColors.textoSecundario,
                      maxLines: 2,
                    ),
                  ],
                )
              : const AppLabel(
                  text: 'No tienes un combo activo asignado en este momento.',
                  variant: AppLabelVariant.cuerpo,
                  color: AppColors.textoSecundario,
                ),
        ),
        const SizedBox(height: 18),

        // 2. Tarjeta: "Mi saldo actual:"
        InfoCard(
          titulo: 'Mi saldo actual:',
          icono: Icons.account_balance_wallet_rounded,
          colorIcono: AppColors.primario,
          colorFondoIcono: AppColors.primarioClaro,
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabel(
                text: '\$${usuario.saldo.toStringAsFixed(2)}',
                variant: AppLabelVariant.monto,
                color: AppColors.primario,
              ),
              const SizedBox(height: 4),
              const AppLabel(
                text: 'Fondo disponible para emitir recargas y paquetes a clientes.',
                variant: AppLabelVariant.pequena,
                color: AppColors.textoSecundario,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 3. Botón Primario: "RECARGAS Y COMBOS"
        AppButton(
          text: 'RECARGAS Y COMBOS',
          icon: Icons.bolt_rounded,
          onPressed: onNuevaRecarga,
        ),
        const SizedBox(height: 14),

        // 4. Botón de Peligro: "CERRAR SESIÓN"
        AppButton(
          text: 'CERRAR SESIÓN',
          variant: AppButtonVariant.peligro,
          icon: Icons.logout_rounded,
          onPressed: onCerrarSesion,
        ),
      ],
    );
  }
}

