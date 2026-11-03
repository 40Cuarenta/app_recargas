import 'package:flutter/material.dart';

/// Modelo inmutable que representa una compañía de telecomunicaciones en Ecuador.
class Operadora {
  /// Identificador único de la operadora (ej. "movistar", "cnt", "tuenti").
  final String id;

  /// Nombre público de la operadora.
  final String nombre;

  /// Icono representativo de Material Icons para renderizado eficiente.
  final IconData icono;

  /// Color corporativo distintivo para branding y badges en la interfaz.
  final Color colorCorporativo;

  /// Porcentaje de comisión cobrado al usuario final (ej. 0.03 = 3%, 0.05 = 5%).
  final double porcentajeComision;

  /// Porcentaje de ganancia o utilidad que recibe el establecimiento (ej. 0.04 = 4%).
  final double porcentajeGanancia;

  const Operadora({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.colorCorporativo,
    required this.porcentajeComision,
    required this.porcentajeGanancia,
  });

  /// Permite generar una copia inmutable modificando atributos específicos.
  Operadora copyWith({
    String? id,
    String? nombre,
    IconData? icono,
    Color? colorCorporativo,
    double? porcentajeComision,
    double? porcentajeGanancia,
  }) {
    return Operadora(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      colorCorporativo: colorCorporativo ?? this.colorCorporativo,
      porcentajeComision: porcentajeComision ?? this.porcentajeComision,
      porcentajeGanancia: porcentajeGanancia ?? this.porcentajeGanancia,
    );
  }
}

