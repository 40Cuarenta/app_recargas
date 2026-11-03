import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// Átomo: Campo de texto de formulario personalizable basado en [TextFormField].
/// Integra soporte para etiquetas, íconos de prefijo/sufijo, validación,
/// formateadores de entrada y alternancia de visibilidad en campos de contraseña.
class AppTextField extends StatefulWidget {
  /// Etiqueta descriptiva superior del campo.
  final String label;

  /// Texto de ayuda o placeholder temporal cuando el campo está vacío.
  final String? hintText;

  /// Controlador para gestionar el valor del texto externamente.
  final TextEditingController? controller;

  /// Función validadora que retorna un mensaje de error o null si es válido.
  final FormFieldValidator<String>? validator;

  /// Tipo de teclado adecuado para el campo (texto, teléfono, número, etc.).
  final TextInputType keyboardType;

  /// Indica si el campo oculta los caracteres (útil para contraseñas).
  final bool isPassword;

  /// Ícono posicionado al inicio del campo de texto.
  final IconData? prefixIcon;

  /// Widget personalizado opcional al final del campo.
  final Widget? suffixIcon;

  /// Lista de formateadores (ej. filtrado de dígitos, límites de longitud).
  final List<TextInputFormatter>? inputFormatters;

  /// Callback que se dispara cada vez que el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Determina si el campo está activo para interacción.
  final bool enabled;

  /// Acción a realizar en el teclado (ej. TextInputAction.next, TextInputAction.done).
  final TextInputAction? textInputAction;

  /// Nodo de foco asociado al campo.
  final FocusNode? focusNode;

  /// Callback ejecutado cuando se presiona la tecla de acción del teclado.
  final VoidCallback? onEditingComplete;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _ocultarTexto;

  @override
  void initState() {
    super.initState();
    _ocultarTexto = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Resolver el widget de sufijo: si es contraseña, permitir mostrar/ocultar
    Widget? sufijo = widget.suffixIcon;
    if (widget.isPassword) {
      sufijo = IconButton(
        icon: Icon(
          _ocultarTexto ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textoSecundario,
          size: 22,
        ),
        onPressed: () {
          setState(() {
            _ocultarTexto = !_ocultarTexto;
          });
        },
        tooltip: _ocultarTexto ? 'Mostrar contraseña' : 'Ocultar contraseña',
      );
    }

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _ocultarTexto,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      style: const TextStyle(
        color: AppColors.textoPrincipal,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppColors.textoSecundario,
                size: 22,
              )
            : null,
        suffixIcon: sufijo,
      ),
    );
  }
}

