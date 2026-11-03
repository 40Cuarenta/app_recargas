import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación de Recargas Electrónicas.
/// Diseñada con un enfoque moderno de Fintech y Telecomunicaciones,
/// garantizando alta legibilidad, contraste y jerarquía visual.
class AppColors {
  AppColors._(); // Constructor privado para evitar instanciación

  // --- Colores Principales de Marca (Fintech & Conectividad) ---
  /// Azul Zafiro vibrante: transmite solidez financiera, confianza y tecnología.
  static const Color primario = Color(0xFF1D4ED8);
  static const Color primarioOscuro = Color(0xFF1E3A8A);
  static const Color primarioClaro = Color(0xFFDBEAFE);

  /// Verde Azulado / Teal: simboliza conectividad móvil, frescura y rapidez.
  static const Color secundario = Color(0xFF0D9488);
  static const Color secundarioOscuro = Color(0xFF115E59);
  static const Color secundarioClaro = Color(0xFFCCFBF1);

  /// Ámbar / Dorado: para promociones, combos especiales y comisiones.
  static const Color acento = Color(0xFFF59E0B);
  static const Color acentoOscuro = Color(0xFF92400E);
  static const Color acentoClaro = Color(0xFFFEF3C7);

  // --- Fondos y Superficies ---
  /// Gris pizarra muy suave (Slate 50): previene la fatiga visual.
  static const Color fondo = Color(0xFFF8FAFC);

  /// Blanco puro para tarjetas elevadas, hojas inferiores y diálogos.
  static const Color superficie = Color(0xFFFFFFFF);

  /// Gris sutil (Slate 100) para fondos de campos de texto y chips inactivos.
  static const Color superficieVariante = Color(0xFFF1F5F9);

  // --- Tipografía y Contraste ---
  /// Texto principal (Slate 900): contraste óptimo según normas WCAG AAA.
  static const Color textoPrincipal = Color(0xFF0F172A);

  /// Texto secundario (Slate 500): ideal para subtítulos, etiquetas y descripciones.
  static const Color textoSecundario = Color(0xFF64748B);

  /// Placeholder / Pista (Slate 400): para textos de ayuda en formularios.
  static const Color textoPista = Color(0xFF94A3B8);

  /// Texto claro / blanco para fondos oscuros o botones principales.
  static const Color textoBlanco = Color(0xFFFFFFFF);

  // --- Estados de Negocio y Notificaciones ---
  /// Verde esmeralda: para comprobantes exitosos y saldo positivo.
  static const Color exito = Color(0xFF16A34A);
  static const Color exitoOscuro = Color(0xFF15803D);
  static const Color exitoFondo = Color(0xFFDCFCE7);

  /// Rojo carmesí: para errores de validación y fallos de transacción.
  static const Color error = Color(0xFFDC2626);
  static const Color errorFondo = Color(0xFFFEE2E2);

  /// Color para acciones destructivas o de advertencia (ej. "Cerrar sesión").
  static const Color peligro = Color(0xFFE11D48);
  static const Color peligroFondo = Color(0xFFFFE4E6);

  // --- Elementos de Estructura ---
  /// Divisores y bordes sutiles entre secciones.
  static const Color borde = Color(0xFFE2E8F0);
  static const Color bordeEnfocado = Color(0xFF1D4ED8);
  static const Color sombra = Color(0x0F0F172A);
}

