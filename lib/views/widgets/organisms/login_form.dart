import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../atoms/app_button.dart';
import '../atoms/app_label.dart';
import '../atoms/app_title.dart';
import '../molecules/login_form_fields.dart';

/// Organismo: Formulario completo de inicio de sesión con validación reactiva.
/// Corresponde a la sección central de la "Pantalla de Inicio de Sesión" (Mockup 1).
/// Combina la molécula [LoginFormFields] y los átomos [AppButton], [AppTitle] y [AppLabel].
class LoginForm extends StatelessWidget {
  /// Llave global para validar el estado de los campos de texto del formulario.
  final GlobalKey<FormState> formKey;

  /// Controlador para el campo de usuario.
  final TextEditingController usuarioController;

  /// Controlador para el campo de contraseña.
  final TextEditingController contrasenaController;

  /// Callback ejecutado cuando el usuario presiona "Iniciar sesión".
  final VoidCallback onSubmit;
  final VoidCallback onLimpiar;

  /// Indica si se está procesando la solicitud de autenticación (muestra spinner en el botón).
  final bool isLoading;

  /// Mensaje de error reactivo opcional (ej. credenciales inválidas).
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usuarioController,
    required this.contrasenaController,
    required this.onSubmit,
    required this.onLimpiar,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título indicativo del prototipo
          const AppTitle(
            text: 'Ingrese su Usuario y Contraseña',
            size: AppTitleSize.pequeno,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Molécula de campos de texto
          LoginFormFields(
            usuarioController: usuarioController,
            contrasenaController: contrasenaController,
            enabled: !isLoading,
            onSubmitted: onSubmit,
          ),

          // Banner de error reactivo si las credenciales fallan
          if (errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 20,
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
          const SizedBox(height: 24),

          // Botón de acción principal
          AppButton(
            text: 'Iniciar sesión',
            icon: Icons.login_rounded,
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Limpiar',
            icon: Icons.cleaning_services_outlined,
            variant: AppButtonVariant.secundario,
            onPressed: isLoading ? null : onLimpiar,
          ),
        ],
      ),
    );
  }
}
