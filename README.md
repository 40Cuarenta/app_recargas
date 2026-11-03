# Aplicación de Recargas Electrónicas Ecuador 

Sistema de simulación de venta y liquidación de recargas y combos celulares para puntos de venta en Ecuador. Construido con **Flutter**, aplicando rigurosamente **Atomic Design**, arquitectura **MVC**, diseño de **Material 3**, rutas nombradas centralizadas y gestión de estado reactiva con **Provider (`ChangeNotifier`)**.

---

## Arquitectura del Proyecto

El proyecto sigue una separación estricta de responsabilidades en tres capas arquitecturales:

1. **Modelos (`lib/models/`)**: Entidades de datos inmutables con constructores `const` y métodos `copyWith`.
2. **Controladores (`lib/controllers/`)**: Lógica de negocio y finanzas desacoplada de la interfaz gráfica usando `ChangeNotifier` (`AuthController` y `RecargaController`).
3. **Vistas (`lib/views/`)**: Jerarquía visual modular basada en **Atomic Design**:
   - **Átomos (`lib/views/widgets/atoms/`)**: Componentes indivisibles (botones, campos de texto, títulos, etiquetas, badges).
   - **Moléculas (`lib/views/widgets/molecules/`)**: Agrupaciones de átomos con propósito funcional simple (tarjetas de paquete, fichas de operadora, filas de resumen, selectores segmentados).
   - **Organismos (`lib/views/widgets/organisms/`)**: Secciones complejas e independientes (formulario de login, cuadrícula de operadoras, formulario de recarga, comprobante financiero, animación de éxito).
   - **Pantallas (`lib/views/screens/`)**: Vistas completas (`Scaffold`) que conectan los organismos a los controladores.

---

## Estructura de Carpetas (`lib/`)

```text
lib/
├── config/
│   └── rutas.dart                      # Exportación y compatibilidad de rutas
├── controllers/
│   ├── auth_controller.dart            # Sesión, login, logout y actualización de saldo
│   └── recarga_controller.dart         # Estado del flujo de recarga, cálculos y confirmación
├── core/
│   ├── routes/
│   │   └── app_routes.dart             # Centralización de rutas nombradas y onGenerateRoute
│   ├── theme/
│   │   ├── app_colors.dart             # Paleta cromática Fintech & Telecom (sin colores hardcodeados)
│   │   ├── app_text_styles.dart        # Jerarquía tipográfica local ('AppFont')
│   │   └── app_theme.dart              # ThemeData Material 3, InputDecorationTheme, botones
│   └── utils/
│       └── validators.dart             # Validadores estáticos puros para formularios
├── data/
│   └── datos_simulados.dart            # Mock data (operadoras, paquetes, usuarios y reglas financieras)
├── models/
│   ├── operadora.dart                  # Modelo de compañía de telecomunicaciones
│   ├── paquete.dart                    # Modelo de combo / paquete de datos y vigencia
│   ├── recarga.dart                    # Modelo de transacción y comprobante digital
│   └── usuario.dart                    # Modelo de usuario / punto de venta
├── views/
│   ├── screens/
│   │   ├── comprobante_screen.dart     # Paso 4: Detalle pre-liquidación y medio de pago
│   │   ├── home_screen.dart            # Pantalla principal (Bienvenida, Mi Combo, Saldo)
│   │   ├── login_screen.dart           # Inicio de sesión con credenciales
│   │   ├── nueva_recarga_screen.dart   # Paso 3: Selección de monto o catálogo de combos
│   │   ├── numero_recarga_screen.dart  # Paso 1: Ingreso y validación de número celular
│   │   ├── operadoras_screen.dart      # Paso 2: Selección de operadora móvil
│   │   └── pago_exitoso_screen.dart    # Paso 5: Animación de éxito y comprobante final
│   └── widgets/
│       ├── atoms/                      # Átomos (AppButton, AppTextField, AppLogo, AppLabel, etc.)
│       ├── molecules/                  # Moléculas (InfoCard, OperadoraTile, PaqueteCard, etc.)
│       └── organisms/                  # Organismos (LoginForm, ComprobanteDetalle, etc.)
└── main.dart                           # Punto de entrada con MultiProvider y MaterialApp
```

---

## Usuarios de Prueba (Credenciales)

| Usuario | Contraseña | Nombre Completo | Saldo Inicial | Combo Activo |
| :--- | :--- | :--- | :--- | :--- |
| **`cajero1`** | `123456` | Edison Proaño | **\$150.00** | Movistar Mega Combo (\$10) |
| **`admin`** | `admin123` | María Belén González | **\$520.50** | CNT Corporativo (\$20) |
| **`ventas_sur`** | `recargas2026` | Carlos Andrés Mera | **\$75.25** | Tuenti Semanal (\$5) |

*(La pantalla de inicio de sesión incluye botones táctiles de acceso rápido para autocompletar credenciales).*

---

## Reglas de Negocio y Finanzas

* **Comisión al cliente**:
  $$\text{Comisión} = \text{Valor} \times \% \text{ Comisión}$$
* **Total a liquidar**:
  $$\text{Total} = \text{Valor} + \text{Comisión}$$
* **Ganancia para el punto de venta**:
  $$\text{Ganancia} = \text{Valor} \times \% \text{ Ganancia}$$
* **Regla comercial por volumen**: Si el valor de la recarga es $\ge \$10.00$, la comisión tiene una reducción preferencial de 1 punto porcentual ($-0.01$, piso base 3%).
* **Esquema por operadora**:
  * **Tigo**: 4% comisión cliente (3% si $\ge \$10$) | 5.0% ganancia local
  * **Movistar**: 3% comisión cliente | 4.5% ganancia local (Ej. \$10 recarga $\rightarrow$ \$0.30 comisión $\rightarrow$ **\$10.30 total**, \$0.45 ganancia)
  * **CNT**: 5% comisión cliente (4% si $\ge \$10$) | 6.0% ganancia local
  * **Tuenti**: 3% comisión cliente | 4.0% ganancia local
  * **Aki Móvil**: 4% comisión cliente | 5.5% ganancia local
  * **MaxiPlus**: 5% comisión cliente | 6.5% ganancia local
  * **Flash Móvil**: 3% comisión cliente | 5.0% ganancia local

---

## Flujo de Navegación

```text
[Login] ──▶ [Home / Dashboard] ──▶ [Paso 1: Número] ──▶ [Paso 2: Operadora]
                                                                  │
[Home (Saldo descontado)] ◀── [Pago Exitoso] ◀── [Comprobante] ◀─ [Paso 3: Combo/Recarga]
```

* **Cerrar Sesión**: Muestra un `AlertDialog` de confirmación y regresa al `Login` limpiando el stack (`pushNamedAndRemoveUntil`).
* **Pago Exitoso**: Al presionar *"Volver a pantalla principal"*, resetea el controlador y regresa al `Home` limpiando el historial de navegación.
* **Sin paso de datos por argumentos sueltos**: Toda la información de la transacción fluye de manera reactiva mediante `RecargaController` y `AuthController`.

---

## Cómo Ejecutar el Proyecto

### Requisitos Previos
* Flutter SDK $\ge 3.13.5$
* Dispositivo físico, emulador Android/iOS o Windows Desktop

### Comandos

1. **Obtener dependencias**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar análisis de código**:
   ```bash
   flutter analyze
   ```
   *(Resultado: 0 warnings, 0 errores).*

3. **Ejecutar suite de pruebas unitarias y de widgets**:
   ```bash
   flutter test
   ```
   *(Valida todas las reglas de negocio, validaciones y flujos).*

4. **Lanzar la aplicación**:
   ```bash
   flutter run
   ```
