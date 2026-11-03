import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Definición centralizada de estilos tipográficos para la aplicación.
/// Utiliza la fuente local configurada en pubspec ('AppFont') con una jerarquía
/// proporcional que garantiza legibilidad en títulos, datos financieros y etiquetas.
class AppTextStyles {
  AppTextStyles._();

  static const String familiaFuente = 'AppFont';

  // --- Títulos y Encabezados ---
  /// Título grande (26sp, Bold): usado en pantallas de inicio, bienvenida o encabezados mayores.
  static const TextStyle tituloGrande = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textoPrincipal,
    letterSpacing: -0.5,
    height: 1.25,
  );

  /// Título mediano (20sp, Bold): usado en AppBar, títulos de sección y diálogos.
  static const TextStyle tituloMedio = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textoPrincipal,
    letterSpacing: -0.3,
    height: 1.3,
  );

  /// Título pequeño (17sp, SemiBold): para nombres de tarjetas u operadoras.
  static const TextStyle tituloPequeno = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textoPrincipal,
    height: 1.35,
  );

  // --- Subtítulos ---
  /// Subtítulo mediano (15sp, Medium): explicaciones breves bajo títulos.
  static const TextStyle subtitulo = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textoSecundario,
    height: 1.4,
  );

  // --- Cuerpo de Texto ---
  /// Cuerpo grande (16sp, Regular): texto principal de lectura.
  static const TextStyle cuerpoGrande = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textoPrincipal,
    height: 1.45,
  );

  /// Cuerpo mediano (14sp, Regular): párrafos informativos estándar.
  static const TextStyle cuerpoMedio = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textoPrincipal,
    height: 1.4,
  );

  /// Cuerpo pequeño (12sp, Regular): notas legales, detalles de vigencia.
  static const TextStyle cuerpoPequeno = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textoSecundario,
    height: 1.35,
  );

  // --- Etiquetas (Labels) ---
  /// Etiqueta grande (14sp, SemiBold): etiquetas de campos de formulario e items destacados.
  static const TextStyle etiquetaGrande = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textoSecundario,
    letterSpacing: 0.1,
  );

  /// Etiqueta pequeña (11sp, Bold): badges de comisión, estado o vigencia corta.
  static const TextStyle etiquetaPequena = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textoSecundario,
    letterSpacing: 0.3,
  );

  // --- Botones ---
  /// Texto de botón primario (15sp, Bold).
  static const TextStyle boton = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textoBlanco,
    letterSpacing: 0.3,
  );

  /// Texto de botón secundario (15sp, SemiBold).
  static const TextStyle botonSecundario = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primario,
    letterSpacing: 0.2,
  );

  /// Texto de botón destructivo o peligro (15sp, Bold).
  static const TextStyle botonPeligro = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.peligro,
    letterSpacing: 0.2,
  );

  // --- Cifras Financieras y Montos ---
  /// Cifra destacada (30sp, Bold): monto total en comprobantes y saldo en pantalla principal.
  static const TextStyle montoDestacado = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.primario,
    letterSpacing: -0.5,
  );

  /// Cifra mediana (20sp, Bold): valores en tarjetas de paquetes.
  static const TextStyle montoMediano = TextStyle(
    fontFamily: familiaFuente,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textoPrincipal,
    letterSpacing: -0.3,
  );
}

