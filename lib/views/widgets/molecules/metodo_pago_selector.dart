import 'package:flutter/material.dart';
import '../../../models/recarga.dart';
import '../atoms/app_chip_option.dart';

/// Molécula: Selector de medio de pago para liquidación transaccional.
/// Corresponde a la sección "Método de pago" del Mockup 4 (Comprobante).
/// Reutiliza el átomo [AppChipOption] para alternar entre "Débito de cuenta" y "Tarjeta".
class MetodoPagoSelector extends StatelessWidget {
  /// Medio de pago seleccionado actualmente ([MetodoPago.debitoCuenta] o [MetodoPago.tarjeta]).
  final MetodoPago metodoSeleccionado;

  /// Callback emitido al cambiar de método de pago.
  final ValueChanged<MetodoPago> onMetodoChanged;

  /// Saldo disponible opcional para mostrar como ayuda visual en "Débito de cuenta".
  final double? saldoDisponible;

  const MetodoPagoSelector({
    super.key,
    required this.metodoSeleccionado,
    required this.onMetodoChanged,
    this.saldoDisponible,
  });

  @override
  Widget build(BuildContext context) {
    final String? subtituloDebito = saldoDisponible != null
        ? 'Disp: \$${saldoDisponible!.toStringAsFixed(2)}'
        : null;

    return Row(
      children: [
        // Opción 1: Débito de cuenta (descuento de saldo del punto de venta)
        Expanded(
          child: AppChipOption(
            label: 'Débito de cuenta',
            subtitle: subtituloDebito,
            icon: Icons.account_balance_wallet_rounded,
            isSelected: metodoSeleccionado == MetodoPago.debitoCuenta,
            onTap: () => onMetodoChanged(MetodoPago.debitoCuenta),
          ),
        ),
        const SizedBox(width: 12),

        // Opción 2: Tarjeta (débito/crédito directa)
        Expanded(
          child: AppChipOption(
            label: 'Tarjeta',
            subtitle: 'Crédito o débito',
            icon: Icons.credit_card_rounded,
            isSelected: metodoSeleccionado == MetodoPago.tarjeta,
            onTap: () => onMetodoChanged(MetodoPago.tarjeta),
          ),
        ),
      ],
    );
  }
}

