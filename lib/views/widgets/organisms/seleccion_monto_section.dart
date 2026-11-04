import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../models/operadora.dart';
import '../../../models/paquete.dart';
import '../../../models/recarga.dart';
import '../atoms/app_chip_option.dart';
import '../atoms/app_icon_badge.dart';
import '../atoms/app_label.dart';
import '../atoms/app_text_field.dart';
import '../atoms/app_title.dart';
import '../molecules/paquete_card.dart';
import '../molecules/selector_tipo_recarga.dart';

/// Organismo: Sección modular para la selección de tipo de servicio y monto.
/// Implementa la estructura del Mockup 3 ("Pantalla de Combos y Recargas"):
/// - Ficha de contexto del número y operadora destino.
/// - Selector segmentado: [Recargas] vs [Paquetes].
/// - Si es Recarga: Campo numérico de valor libre + chips de montos rápidos.
/// - Si es Paquete: Catálogo interactivo de combos con gigas, vigencia y precio.
/// Se incorpora al formulario único de la pantalla principal.
class SeleccionMontoSection extends StatelessWidget {
  /// Número celular al que se aplicará el servicio.
  final String numeroTelefono;

  /// Operadora móvil seleccionada en el paso anterior.
  final Operadora operadora;

  /// Modalidad activa ([TipoRecarga.recarga] o [TipoRecarga.paquete]).
  final TipoRecarga tipoSeleccionado;

  /// Callback para conmutar entre recarga directa o paquete.
  final ValueChanged<TipoRecarga> onTipoChanged;

  /// Controlador para el campo de texto de monto monetario.
  final TextEditingController valorController;

  /// Catálogo de paquetes disponibles para la operadora.
  final List<Paquete> paquetes;

  /// Paquete actualmente seleccionado (si la modalidad es paquete).
  final Paquete? paqueteSeleccionado;

  /// Callback al elegir un paquete del catálogo.
  final ValueChanged<Paquete> onPaqueteSeleccionado;

  /// Callback al seleccionar un chip de valor monetario rápido.
  final ValueChanged<double> onValorRapidoSeleccionado;

  const SeleccionMontoSection({
    super.key,
    required this.numeroTelefono,
    required this.operadora,
    required this.tipoSeleccionado,
    required this.onTipoChanged,
    required this.valorController,
    required this.paquetes,
    required this.paqueteSeleccionado,
    required this.onPaqueteSeleccionado,
    required this.onValorRapidoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Contexto: Destinatario y Operadora (Mockup: USUARIO / NUMERO DE RECARGA)
        Card(
          color: AppColors.superficie,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AppIconBadge(
                  icon: operadora.icono,
                  size: 46,
                  iconSize: 24,
                  iconColor: operadora.colorCorporativo,
                  backgroundColor: operadora.colorCorporativo.withValues(
                    alpha: 0.12,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabel(
                        text: 'Línea ${operadora.nombre}',
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.superficieVariante,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const AppLabel(
                    text: 'Destino',
                    variant: AppLabelVariant.pequena,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 2. Selector segmentado: "Elige como quieres recargar"
        const AppTitle(
          text: 'Elige como quieres recargar',
          size: AppTitleSize.pequeno,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SelectorTipoRecarga(
          tipoSeleccionado: tipoSeleccionado,
          onTipoChanged: onTipoChanged,
        ),
        const SizedBox(height: 24),

        // 3. Contenido condicional: Recarga Monetaria vs Catálogo de Paquetes
        if (tipoSeleccionado == TipoRecarga.recarga) ...[
          // MODO RECARGAS DE SALDO
          const AppTitle(
            text: 'Ingrese el monto a recargar',
            size: AppTitleSize.pequeno,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: valorController,
            label: 'Monto en USD (\$) ',
            hintText: 'Ej. 5.00',
            prefixIcon: Icons.attach_money_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: Validators.validarValorRecarga,
            inputFormatters: [
              TextInputFormatter.withFunction((anterior, nuevo) {
                return RegExp(r'^\d*([.,]\d{0,2})?$').hasMatch(nuevo.text)
                    ? nuevo
                    : anterior;
              }),
            ],
          ),
          const SizedBox(height: 14),

          // Chips de valores rápidos
          const AppLabel(
            text: 'Valores frecuentes:',
            variant: AppLabelVariant.pequena,
            color: AppColors.textoSecundario,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [1.0, 2.0, 3.0, 5.0, 10.0, 20.0].map((monto) {
                final bool esSeleccionado =
                    valorController.text == monto.toStringAsFixed(2) ||
                    valorController.text == monto.toInt().toString();

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AppChipOption(
                    label: '\$${monto.toStringAsFixed(2)}',
                    isSelected: esSeleccionado,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    onTap: () => onValorRapidoSeleccionado(monto),
                  ),
                );
              }).toList(),
            ),
          ),
        ] else ...[
          // MODO PAQUETES / COMBOS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: AppTitle(
                  text: 'Combos disponibles',
                  size: AppTitleSize.pequeno,
                ),
              ),
              const SizedBox(width: 12),
              AppLabel(
                text: '${paquetes.length} opciones',
                variant: AppLabelVariant.pequena,
                color: AppColors.textoSecundario,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de tarjetas de paquetes
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paquetes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final paquete = paquetes[index];
              final bool isSelected = paqueteSeleccionado?.id == paquete.id;

              return PaqueteCard(
                paquete: paquete,
                isSelected: isSelected,
                onTap: () => onPaqueteSeleccionado(paquete),
              );
            },
          ),
        ],
      ],
    );
  }
}
