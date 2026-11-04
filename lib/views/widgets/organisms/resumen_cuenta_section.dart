import 'package:flutter/material.dart';

import '../../../models/usuario.dart';
import '../atoms/app_label.dart';

/// Organismo de consulta de saldo y combo de la cuenta de prueba.
class ResumenCuentaSection extends StatelessWidget {
  final Usuario usuario;
  const ResumenCuentaSection({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLabel(text: 'Mi saldo actual'),
            AppLabel(
              text: '\$${usuario.saldo.toStringAsFixed(2)}',
              variant: AppLabelVariant.monto,
            ),
            const Divider(),
            AppLabel(
              text:
                  'Mi combo: ${usuario.comboActual?.nombre ?? 'Sin combo activo'}',
            ),
            if (usuario.comboActual != null)
              AppLabel(
                text:
                    '\$${usuario.comboActual!.precio.toStringAsFixed(2)} · ${usuario.comboActual!.descripcion} · Vigencia: ${usuario.comboActual!.vigencia}',
                variant: AppLabelVariant.pequena,
              ),
          ],
        ),
      ),
    );
  }
}
