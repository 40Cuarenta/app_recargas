import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../atoms/app_button.dart';
import '../atoms/app_chip_option.dart';
import '../atoms/app_label.dart';
import '../atoms/app_text_field.dart';
import '../atoms/app_title.dart';

/// Organismo: Formulario para el ingreso y validación del número telefónico de recarga.
/// Corresponde a la "Pantalla de Número a Recargar" (Mockup 2).
/// Valida el formato ecuatoriano de 10 dígitos (prefijo 09).
class NumeroRecargaForm extends StatelessWidget {
  /// Llave del formulario para activar la validación antes de avanzar.
  final GlobalKey<FormState> formKey;

  /// Controlador del campo de texto telefónico.
  final TextEditingController telefonoController;

  /// Callback ejecutado al presionar el botón "CONTINUAR".
  final VoidCallback onContinuar;

  /// Indica si la acción está en procesamiento.
  final bool isLoading;

  const NumeroRecargaForm({
    super.key,
    required this.formKey,
    required this.telefonoController,
    required this.onContinuar,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título y guía visual del mockup
          const AppTitle(
            text: 'Número a recarga',
            size: AppTitleSize.medio,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const AppLabel(
            text: 'Ingresa el número celular de 10 dígitos que recibirá la recarga',
            variant: AppLabelVariant.subtitulo,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Campo de texto de teléfono validado
          AppTextField(
            controller: telefonoController,
            label: 'Número Celular (Ecuador)',
            hintText: '09xxxxxxxx',
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onEditingComplete: onContinuar,
            validator: Validators.validarTelefono,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 16),

          // Números de prueba rápidos para agilizar la simulación
          const AppLabel(
            text: 'Números de prueba rápidos:',
            variant: AppLabelVariant.pequena,
            color: AppColors.textoSecundario,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AppChipOption(
                  label: '0991234567',
                  isSelected: telefonoController.text == '0991234567',
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onTap: () {
                    telefonoController.text = '0991234567';
                    telefonoController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 10),
                    );
                  },
                ),
                const SizedBox(width: 8),
                AppChipOption(
                  label: '0987654321',
                  isSelected: telefonoController.text == '0987654321',
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onTap: () {
                    telefonoController.text = '0987654321';
                    telefonoController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 10),
                    );
                  },
                ),
                const SizedBox(width: 8),
                AppChipOption(
                  label: '0961122334',
                  isSelected: telefonoController.text == '0961122334',
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onTap: () {
                    telefonoController.text = '0961122334';
                    telefonoController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 10),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Botón Continuar
          AppButton(
            text: 'CONTINUAR',
            icon: Icons.arrow_forward_rounded,
            isLoading: isLoading,
            onPressed: onContinuar,
          ),
        ],
      ),
    );
  }
}

