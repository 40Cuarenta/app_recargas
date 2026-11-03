/// Modelo inmutable que representa un paquete o combo de telefonía móvil.
class Paquete {
  /// Identificador único del paquete.
  final String id;

  /// Nombre comercial del combo (ej. "Súper Combo Semanal").
  final String nombre;

  /// Precio nominal del paquete en dólares estadounidenses (USD).
  final double precio;

  /// Período de validez del paquete (ej. "1 día", "7 días", "30 días").
  final String vigencia;

  /// Cantidad de datos de navegación móvil en Gigabytes (GB).
  final double datos;

  /// Detalle de beneficios adicionales (ej. "WhatsApp y redes sociales ilimitadas").
  final String descripcion;

  /// Clave foránea que asocia el paquete a su operadora respectiva.
  final String operadoraId;

  const Paquete({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.vigencia,
    required this.datos,
    required this.descripcion,
    required this.operadoraId,
  });

  /// Permite generar una copia inmutable modificando atributos específicos.
  Paquete copyWith({
    String? id,
    String? nombre,
    double? precio,
    String? vigencia,
    double? datos,
    String? descripcion,
    String? operadoraId,
  }) {
    return Paquete(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      vigencia: vigencia ?? this.vigencia,
      datos: datos ?? this.datos,
      descripcion: descripcion ?? this.descripcion,
      operadoraId: operadoraId ?? this.operadoraId,
    );
  }
}

