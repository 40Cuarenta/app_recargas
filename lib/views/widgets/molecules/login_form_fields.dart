import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../atoms/app_text_field.dart';

/// Molécula: Conjunto acoplado de campos de entrada para el formulario de login.
/// Reutiliza exclusivamente el átomo [AppTextField] e incorpora los validadores de negocio.
class LoginFormFields extends StatelessWidget {
  /// Controlador para el campo de nombre de usuario.
  final TextEditingController usuarioController;

  /// Controlador para el campo de contraseña.
  final TextEditingController contrasenaController;

  /// Callback opcional al enviar el formulario desde el teclado.
  final VoidCallback? onSubmitted;

  /// Estado de interactividad de los campos (se deshabilita al procesar autenticación).
  final bool enabled;

  const LoginFormFields({
    super.key,
    required this.usuarioController,
    required this.contrasenaController,
    this.onSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campo: Usuario
        AppTextField(
          controller: usuarioController,
          label: 'Usuario',
          hintText: 'Ingrese su nombre de usuario',
          prefixIcon: Icons.person_outline_rounded,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          validator: Validators.validarUsuario,
        ),
        const SizedBox(height: 16),

        // Campo: Contraseña
        AppTextField(
          controller: contrasenaController,
          label: 'Contraseña',
          hintText: 'Ingrese su contraseña',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          enabled: enabled,
          textInputAction: TextInputAction.done,
          onEditingComplete: onSubmitted,
          validator: Validators.validarContrasena,
        ),
      ],
    );
  }
}

