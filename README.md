# Aplicación de recargas electrónicas

Simulación educativa en Flutter para la opción 2 del Informe 1.2. Conserva MVC,
Atomic Design, Provider y el tema original. Los usuarios, precios y porcentajes
son datos de prueba; no se conecta a bancos ni a operadoras.

## Tres pantallas

1. **Inicio de sesión (`/`)**: usuario, contraseña, mostrar/ocultar contraseña,
   validación, acceso rápido de prueba y botón **Limpiar**.
2. **Principal (`/home`)**: cuenta, saldo, combo actual, teléfono, operadora,
   recarga directa o paquete, montos rápidos y método de pago. Permite revisar
   la operación, limpiar el formulario y cerrar sesión con confirmación.
3. **Comprobante (`/comprobante`)**: detalle, comisión, total, ganancia y confirmación.
   Tras pagar, esta misma pantalla muestra la animación y el recibo final.
   Volver antes de pagar conserva los datos; volver después limpia el formulario.

## Organización

- `lib/models/`: usuario, operadora, paquete y recarga.
- `lib/controllers/`: sesión y flujo de recarga con `ChangeNotifier`.
- `lib/views/widgets/atoms/`: botones, textos, campos y selección.
- `lib/views/widgets/molecules/`: selector de operadora, pago y tarjetas.
- `lib/views/widgets/organisms/`: formularios, cuenta y comprobante.
- `lib/views/screens/`: las tres pantallas.
- `lib/core/`: rutas, tema, validadores y formato de porcentajes.
- `lib/data/datos_simulados.dart`: catálogos y reglas de liquidación.

## Cuentas de prueba

| Usuario | Contraseña | Saldo inicial |
|---|---|---:|
| cajero1 | 123456 | $150.00 |
| admin | admin123 | $520.50 |
| ventas_sur | recargas2026 | $75.25 |

## Cálculos

- Comisión = valor base × porcentaje efectivo de comisión.
- Total = valor base + comisión.
- Ganancia estimada = valor base × porcentaje de ganancia.
- Desde $10, una comisión mayor al 3 % baja un punto porcentual.
- Los porcentajes fraccionarios se muestran sin convertir 6,5 % en 7 %.
- Débito de cuenta valida y descuenta el total; tarjeta solo simula aprobación.
- La ganancia se informa y no se acredita al saldo. El estado se conserva en
  memoria durante la sesión y no hay historial permanente.
- Recarga directa: entre $1 y $100 y hasta dos decimales, con punto o coma.
- Teléfono: diez dígitos e inicio 09. Los paquetes pertenecen a su operadora.

Ejemplo: Movistar, $10 → comisión $0.30, total $10.30, ganancia $0.45.

## Ejecutar

Se requiere Flutter con Dart compatible con `^3.13.5` y un dispositivo conectado.
Desde esta carpeta:

```powershell
flutter pub get
flutter devices
flutter run -t lib/main.dart
```

Para verificar:

```powershell
flutter analyze
flutter test
flutter build apk --debug
```
