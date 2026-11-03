import 'package:flutter/material.dart';
import '../models/operadora.dart';
import '../models/paquete.dart';
import '../models/usuario.dart';

/// Fuente de datos simulada en memoria (Mock Data) para la aplicación.
/// Proporciona operadoras con comisiones variables, paquetes detallados,
/// usuarios con saldo inicial y la lógica de cálculo de liquidación comercial.
class DatosSimulados {
  DatosSimulados._();

  // ===========================================================================
  // 1. OPERADORAS DE TELEFONÍA (Móviles de Ecuador y Ficticias)
  // ===========================================================================
  static const List<Operadora> operadoras = [
    Operadora(
      id: 'tigo',
      nombre: 'Tigo',
      icono: Icons.cell_tower_rounded,
      colorCorporativo: Color(0xFF00377B),
      porcentajeComision: 0.04, // 4%
      porcentajeGanancia: 0.05, // 5% de utilidad para el establecimiento
    ),
    Operadora(
      id: 'movistar',
      nombre: 'Movistar',
      icono: Icons.wifi_tethering_rounded,
      colorCorporativo: Color(0xFF00A9E0),
      porcentajeComision: 0.03, // 3%
      porcentajeGanancia: 0.045, // 4.5%
    ),
    Operadora(
      id: 'cnt',
      nombre: 'CNT',
      icono: Icons.signal_cellular_alt_rounded,
      colorCorporativo: Color(0xFF0089CF),
      porcentajeComision: 0.05, // 5%
      porcentajeGanancia: 0.06, // 6%
    ),
    Operadora(
      id: 'tuenti',
      nombre: 'Tuenti',
      icono: Icons.tag_faces_rounded,
      colorCorporativo: Color(0xFFFF3366),
      porcentajeComision: 0.03, // 3%
      porcentajeGanancia: 0.04, // 4%
    ),
    Operadora(
      id: 'akimovil',
      nombre: 'Aki Móvil',
      icono: Icons.shopping_bag_rounded,
      colorCorporativo: Color(0xFFE65100),
      porcentajeComision: 0.04, // 4%
      porcentajeGanancia: 0.055, // 5.5%
    ),
    Operadora(
      id: 'maxiplus',
      nombre: 'MaxiPlus',
      icono: Icons.bolt_rounded,
      colorCorporativo: Color(0xFF7C3AED),
      porcentajeComision: 0.05, // 5%
      porcentajeGanancia: 0.065, // 6.5%
    ),
    Operadora(
      id: 'flash',
      nombre: 'Flash Móvil',
      icono: Icons.flash_on_rounded,
      colorCorporativo: Color(0xFFDC2626),
      porcentajeComision: 0.03, // 3%
      porcentajeGanancia: 0.05, // 5%
    ),
  ];

  // ===========================================================================
  // 2. CATÁLOGO DE PAQUETES (Mínimo 5 por operadora: $1, $3, $5, $10, $20)
  // ===========================================================================
  static const List<Paquete> paquetes = [
    // --- TIGO ---
    Paquete(
      id: 'tigo_1',
      nombre: 'Tigo Diario',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.5,
      descripcion: '1.5 GB + WhatsApp sin límites + llamadas Tigo',
      operadoraId: 'tigo',
    ),
    Paquete(
      id: 'tigo_3',
      nombre: 'Tigo Finde',
      precio: 3.00,
      vigencia: '3 días',
      datos: 4.0,
      descripcion: '4 GB + Redes sociales (FB, IG, WA) + 50 min multioperador',
      operadoraId: 'tigo',
    ),
    Paquete(
      id: 'tigo_5',
      nombre: 'Tigo Semanal Con Todo',
      precio: 5.00,
      vigencia: '7 días',
      datos: 8.0,
      descripcion: '8 GB + Redes y llamadas ilimitadas + TikTok nocturno',
      operadoraId: 'tigo',
    ),
    Paquete(
      id: 'tigo_10',
      nombre: 'Tigo Quincenal Pro',
      precio: 10.00,
      vigencia: '15 días',
      datos: 20.0,
      descripcion: '20 GB + Todo ilimitado + Streaming libre',
      operadoraId: 'tigo',
    ),
    Paquete(
      id: 'tigo_20',
      nombre: 'Tigo Max Mensual',
      precio: 20.00,
      vigencia: '30 días',
      datos: 45.0,
      descripcion: '45 GB de navegación ultrarrápida + llamadas y roaming',
      operadoraId: 'tigo',
    ),

    // --- MOVISTAR ---
    Paquete(
      id: 'mov_1',
      nombre: 'Combo Diario Movi',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.2,
      descripcion: '1.2 GB + WhatsApp libre + 25 minutos',
      operadoraId: 'movistar',
    ),
    Paquete(
      id: 'mov_3',
      nombre: 'Combo Navega 3 Días',
      precio: 3.00,
      vigencia: '3 días',
      datos: 4.5,
      descripcion: '4.5 GB + Redes sociales libres + minutos libres',
      operadoraId: 'movistar',
    ),
    Paquete(
      id: 'mov_5',
      nombre: 'Súper Combo Semanal',
      precio: 5.00,
      vigencia: '7 días',
      datos: 10.0,
      descripcion: '10 GB + WhatsApp, Instagram y Spotify sin consumo',
      operadoraId: 'movistar',
    ),
    Paquete(
      id: 'mov_10',
      nombre: 'Mega Combo Quincenal',
      precio: 10.00,
      vigencia: '15 días',
      datos: 25.0,
      descripcion: '25 GB + Minutos ilimitados + YouTube libre en la noche',
      operadoraId: 'movistar',
    ),
    Paquete(
      id: 'mov_20',
      nombre: 'Ultra Movi Plan 30',
      precio: 20.00,
      vigencia: '30 días',
      datos: 50.0,
      descripcion: '50 GB acumulables + Roaming en América + Apps libres',
      operadoraId: 'movistar',
    ),

    // --- CNT ---
    Paquete(
      id: 'cnt_1',
      nombre: 'CNT Conéctate 1',
      precio: 1.00,
      vigencia: '1 día',
      datos: 2.0,
      descripcion: '2 GB libres + llamadas nacionales ilimitadas CNT',
      operadoraId: 'cnt',
    ),
    Paquete(
      id: 'cnt_3',
      nombre: 'CNT Pack 3',
      precio: 3.00,
      vigencia: '3 días',
      datos: 5.0,
      descripcion: '5 GB + Redes sociales + llamadas multioperador',
      operadoraId: 'cnt',
    ),
    Paquete(
      id: 'cnt_5',
      nombre: 'CNT Familiar Semanal',
      precio: 5.00,
      vigencia: '7 días',
      datos: 12.0,
      descripcion: '12 GB de alta velocidad + minutos y SMS sin límite',
      operadoraId: 'cnt',
    ),
    Paquete(
      id: 'cnt_10',
      nombre: 'CNT Súper Quincena',
      precio: 10.00,
      vigencia: '15 días',
      datos: 28.0,
      descripcion: '28 GB + Llamadas sin límite + Cobertura nacional total',
      operadoraId: 'cnt',
    ),
    Paquete(
      id: 'cnt_20',
      nombre: 'CNT Corporativo 30D',
      precio: 20.00,
      vigencia: '30 días',
      datos: 60.0,
      descripcion: '60 GB + Datos libres para teletrabajo y streaming',
      operadoraId: 'cnt',
    ),

    // --- TUENTI ---
    Paquete(
      id: 'tue_1',
      nombre: 'Combo Chiquito',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.0,
      descripcion: '1 GB + WhatsApp y llamadas ilimitadas entre Tuentis',
      operadoraId: 'tuenti',
    ),
    Paquete(
      id: 'tue_3',
      nombre: 'Combo Tri',
      precio: 3.00,
      vigencia: '3 días',
      datos: 3.5,
      descripcion: '3.5 GB + Spotify y WhatsApp gratis + 40 minutos',
      operadoraId: 'tuenti',
    ),
    Paquete(
      id: 'tue_5',
      nombre: 'Combo Semanal Tuenti',
      precio: 5.00,
      vigencia: '7 días',
      datos: 9.0,
      descripcion: '9 GB + TikTok, Instagram y WhatsApp que no gastan gigas',
      operadoraId: 'tuenti',
    ),
    Paquete(
      id: 'tue_10',
      nombre: 'Combo Más Tuenti',
      precio: 10.00,
      vigencia: '15 días',
      datos: 22.0,
      descripcion: '22 GB + Todo ilimitado + Ruleta de premios en app',
      operadoraId: 'tuenti',
    ),
    Paquete(
      id: 'tue_20',
      nombre: 'El Gran Combo 30 Días',
      precio: 20.00,
      vigencia: '30 días',
      datos: 45.0,
      descripcion: '45 GB acumulables + Suscripción musical incluida',
      operadoraId: 'tuenti',
    ),

    // --- AKI MÓVIL ---
    Paquete(
      id: 'aki_1',
      nombre: 'Aki Express',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.5,
      descripcion: '1.5 GB + WhatsApp + saldo para compras en tiendas Aki',
      operadoraId: 'akimovil',
    ),
    Paquete(
      id: 'aki_3',
      nombre: 'Aki Ahorro 3',
      precio: 3.00,
      vigencia: '3 días',
      datos: 4.0,
      descripcion: '4 GB + Redes ilimitadas + 40 min nacionales',
      operadoraId: 'akimovil',
    ),
    Paquete(
      id: 'aki_5',
      nombre: 'Aki Combo Semanal',
      precio: 5.00,
      vigencia: '7 días',
      datos: 10.0,
      descripcion: '10 GB + WhatsApp y Facebook gratis + minutos libres',
      operadoraId: 'akimovil',
    ),
    Paquete(
      id: 'aki_10',
      nombre: 'Aki Quincena Gigas',
      precio: 10.00,
      vigencia: '15 días',
      datos: 24.0,
      descripcion: '24 GB + Llamadas sin límite + descuentos comerciales',
      operadoraId: 'akimovil',
    ),
    Paquete(
      id: 'aki_20',
      nombre: 'Aki Todo Incluido 30D',
      precio: 20.00,
      vigencia: '30 días',
      datos: 50.0,
      descripcion: '50 GB + Cobertura nacional completa y puntos de fidelidad',
      operadoraId: 'akimovil',
    ),

    // --- MAXIPLUS (Operadora Ficticia 1) ---
    Paquete(
      id: 'maxi_1',
      nombre: 'Maxi Flash 1D',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.8,
      descripcion: '1.8 GB + WhatsApp ultra veloz + 30 min',
      operadoraId: 'maxiplus',
    ),
    Paquete(
      id: 'maxi_3',
      nombre: 'Maxi Conect 3D',
      precio: 3.00,
      vigencia: '3 días',
      datos: 5.0,
      descripcion: '5 GB + Apps de mensajería libres + llamadas',
      operadoraId: 'maxiplus',
    ),
    Paquete(
      id: 'maxi_5',
      nombre: 'Maxi Power Semanal',
      precio: 5.00,
      vigencia: '7 días',
      datos: 11.0,
      descripcion: '11 GB + Redes y streaming nocturno sin restricciones',
      operadoraId: 'maxiplus',
    ),
    Paquete(
      id: 'maxi_10',
      nombre: 'Maxi Mega 15D',
      precio: 10.00,
      vigencia: '15 días',
      datos: 26.0,
      descripcion: '26 GB + Navegación 5G + llamadas internacionales',
      operadoraId: 'maxiplus',
    ),
    Paquete(
      id: 'maxi_20',
      nombre: 'Maxi Premium Mes',
      precio: 20.00,
      vigencia: '30 días',
      datos: 55.0,
      descripcion: '55 GB con prioridad de red y atención VIP',
      operadoraId: 'maxiplus',
    ),

    // --- FLASH MÓVIL (Operadora Ficticia 2) ---
    Paquete(
      id: 'fla_1',
      nombre: 'Flash Start',
      precio: 1.00,
      vigencia: '1 día',
      datos: 1.4,
      descripcion: '1.4 GB + Redes sociales básicas + 20 minutos',
      operadoraId: 'flash',
    ),
    Paquete(
      id: 'fla_3',
      nombre: 'Flash Trío',
      precio: 3.00,
      vigencia: '3 días',
      datos: 4.2,
      descripcion: '4.2 GB + WhatsApp, Instagram y llamadas libres',
      operadoraId: 'flash',
    ),
    Paquete(
      id: 'fla_5',
      nombre: 'Flash Total 7D',
      precio: 5.00,
      vigencia: '7 días',
      datos: 10.5,
      descripcion: '10.5 GB + Redes sociales y minutos sin restricciones',
      operadoraId: 'flash',
    ),
    Paquete(
      id: 'fla_10',
      nombre: 'Flash Ultra 15D',
      precio: 10.00,
      vigencia: '15 días',
      datos: 24.0,
      descripcion: '24 GB + Streaming de música y video preferencial',
      operadoraId: 'flash',
    ),
    Paquete(
      id: 'fla_20',
      nombre: 'Flash Master 30D',
      precio: 20.00,
      vigencia: '30 días',
      datos: 52.0,
      descripcion: '52 GB + Minutos ilimitados a Ecuador, USA y Canadá',
      operadoraId: 'flash',
    ),
  ];

  // ===========================================================================
  // 3. USUARIOS DE PRUEBA (Comerciantes / Puntos de Venta con Saldo y Combo)
  // ===========================================================================
  static List<Usuario> usuariosPrueba = [
    Usuario(
      id: 'usr_01',
      nombreUsuario: 'cajero1',
      contrasena: '123456',
      nombreCompleto: 'Edison Proaño',
      saldo: 150.00,
      comboActual: paquetes.firstWhere((p) => p.id == 'mov_10'),
    ),
    Usuario(
      id: 'usr_02',
      nombreUsuario: 'admin',
      contrasena: 'admin123',
      nombreCompleto: 'María Belén González',
      saldo: 520.50,
      comboActual: paquetes.firstWhere((p) => p.id == 'cnt_20'),
    ),
    Usuario(
      id: 'usr_03',
      nombreUsuario: 'ventas_sur',
      contrasena: 'recargas2026',
      nombreCompleto: 'Carlos Andrés Mera',
      saldo: 75.25,
      comboActual: paquetes.firstWhere((p) => p.id == 'tue_5'),
    ),
  ];

  // ===========================================================================
  // 4. LÓGICA DE NEGOCIO Y CÁLCULOS COMERCIALES
  // ===========================================================================

  /// Obtiene la lista de paquetes asociados a una operadora específica.
  static List<Paquete> obtenerPaquetesPorOperadora(String operadoraId) {
    return paquetes.where((p) => p.operadoraId == operadoraId).toList();
  }

  /// Calcula el porcentaje de comisión efectivo aplicando la regla comercial:
  /// Los porcentajes varían según la operadora y, opcionalmente, si el valor
  /// de la recarga es >= $10.00, la comisión baja 1 punto porcentual (manteniendo un piso base de 3%).
  static double calcularPorcentajeComisionEfectivo({
    required Operadora operadora,
    required double valor,
    bool aplicarDescuentoMayor10 = true,
  }) {
    double porcentaje = operadora.porcentajeComision;
    if (aplicarDescuentoMayor10 && valor >= 10.0 && porcentaje > 0.03) {
      // Regla de incentivo: reducción de 1 punto porcentual (piso base 3%)
      porcentaje = (porcentaje - 0.01).clamp(0.0, 1.0);
    }
    return porcentaje;
  }

  /// Realiza la liquidación financiera completa de una operación:
  /// - [comision] = valor × porcentajeComisionEfectivo
  /// - [total] = valor + comision
  /// - [ganancia] = valor × porcentajeGanancia
  static ({
    double comision,
    double total,
    double ganancia,
    double porcentajeComisionAplicado,
  }) calcularLiquidacion({
    required Operadora operadora,
    required double valor,
  }) {
    final double pctComision = calcularPorcentajeComisionEfectivo(
      operadora: operadora,
      valor: valor,
    );
    final double comision = double.parse((valor * pctComision).toStringAsFixed(2));
    final double total = double.parse((valor + comision).toStringAsFixed(2));
    final double ganancia = double.parse((valor * operadora.porcentajeGanancia).toStringAsFixed(2));

    return (
      comision: comision,
      total: total,
      ganancia: ganancia,
      porcentajeComisionAplicado: pctComision,
    );
  }
}

