import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Configuración completa del tema visual de la aplicación (Material 3).
/// Integra la paleta de colores corporativa, tipografía local, estilos de controles,
/// campos de formulario redondeados y variantes específicas de botones.
class AppTheme {
  AppTheme._();

  // --- Estilos Específicos de Botones Solicitados ---

  /// Estilo de botón primario: para flujos de avance ("Iniciar sesión", "Continuar", "Confirmar y pagar").
  static final ButtonStyle botonPrimario = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primario,
    foregroundColor: AppColors.textoBlanco,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: AppTextStyles.boton,
  );

  /// Estilo de botón secundario: para acciones secundarias o alternativas ("Regresar", "Ver detalles").
  static final ButtonStyle botonSecundario = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primario,
    side: const BorderSide(color: AppColors.primario, width: 1.5),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: AppTextStyles.botonSecundario,
  );

  /// Estilo de botón de peligro: especialmente diseñado para "Cerrar sesión" y acciones irreversibles.
  static final ButtonStyle botonPeligro = ElevatedButton.styleFrom(
    backgroundColor: AppColors.peligroFondo,
    foregroundColor: AppColors.peligro,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
    ),
    textStyle: AppTextStyles.botonPeligro,
  );

  // --- Tema Global de la Aplicación ---

  static ThemeData get temaClaro {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primario,
      onPrimary: AppColors.textoBlanco,
      primaryContainer: AppColors.primarioClaro,
      onPrimaryContainer: AppColors.primarioOscuro,
      secondary: AppColors.secundario,
      onSecondary: AppColors.textoBlanco,
      secondaryContainer: AppColors.secundarioClaro,
      onSecondaryContainer: AppColors.secundarioOscuro,
      tertiary: AppColors.acento,
      onTertiary: AppColors.textoBlanco,
      error: AppColors.error,
      onError: AppColors.textoBlanco,
      errorContainer: AppColors.errorFondo,
      onErrorContainer: AppColors.error,
      surface: AppColors.superficie,
      onSurface: AppColors.textoPrincipal,
      surfaceContainerHighest: AppColors.superficieVariante,
      outline: AppColors.borde,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.familiaFuente,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.fondo,

      // --- Tipografía Global ---
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.tituloGrande,
        headlineMedium: AppTextStyles.tituloMedio,
        headlineSmall: AppTextStyles.tituloPequeno,
        titleLarge: AppTextStyles.tituloMedio,
        titleMedium: AppTextStyles.tituloPequeno,
        titleSmall: AppTextStyles.subtitulo,
        bodyLarge: AppTextStyles.cuerpoGrande,
        bodyMedium: AppTextStyles.cuerpoMedio,
        bodySmall: AppTextStyles.cuerpoPequeno,
        labelLarge: AppTextStyles.etiquetaGrande,
        labelSmall: AppTextStyles.etiquetaPequena,
      ),

      // --- Barra Superior (AppBar) ---
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textoPrincipal),
        titleTextStyle: AppTextStyles.tituloMedio,
      ),

      // --- Tarjetas (Cards) ---
      cardTheme: CardThemeData(
        color: AppColors.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borde, width: 1.0),
        ),
      ),

      // --- Campos de Formulario (InputDecoration) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTextStyles.cuerpoMedio.copyWith(color: AppColors.textoPista),
        labelStyle: AppTextStyles.etiquetaGrande,
        errorStyle: AppTextStyles.cuerpoPequeno.copyWith(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borde, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borde, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.bordeEnfocado, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),

      // --- Botones Elevados por Defecto ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: botonPrimario,
      ),

      // --- Botones Delineados por Defecto ---
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: botonSecundario,
      ),

      // --- Botones de Texto ---
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primario,
          textStyle: AppTextStyles.etiquetaGrande,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // --- Divisores ---
      dividerTheme: const DividerThemeData(
        color: AppColors.borde,
        thickness: 1,
        space: 24,
      ),
    );
  }
}

