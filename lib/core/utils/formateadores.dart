/// Mantiene los decimales del porcentaje y elimina únicamente ceros sobrantes.
String formatearPorcentaje(double tasa) {
  return (tasa * 100)
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'\.?0+$'), '')
      .replaceAll('.', ',');
}
