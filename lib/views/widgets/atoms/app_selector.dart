import 'package:flutter/material.dart';

/// Átomo de selección que reutiliza el tema y los errores del formulario.
class AppSelector<T> extends StatelessWidget {
  final String etiqueta;
  final T? valor;
  final List<DropdownMenuItem<T>> opciones;
  final ValueChanged<T?> alCambiar;
  final FormFieldValidator<T>? validar;

  const AppSelector({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.alCambiar,
    this.validar,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: ValueKey(valor),
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: etiqueta),
      items: opciones,
      onChanged: alCambiar,
      validator: validar,
    );
  }
}
