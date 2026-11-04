import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recarga_controller.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/organisms/home_header.dart';
import '../widgets/organisms/resumen_cuenta_section.dart';
import '../widgets/organisms/formulario_recarga.dart';

/// Pantalla 2: cuenta del usuario y formulario completo de recarga.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _cerrarSesion(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('Deberás ingresar tus credenciales nuevamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogo),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogo);
              context.read<AuthController>().logout();
              context.read<RecargaController>().reiniciar();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthController>().usuarioActual;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recargas y combos'),
        actions: [
          if (usuario != null)
            IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => _cerrarSesion(context),
            ),
        ],
      ),
      body: SafeArea(
        child: usuario == null
            ? Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  ),
                  child: const Text('Ir a inicio de sesión'),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeHeader(
                          usuario: usuario,
                          onInfoTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Punto de venta: ${usuario.id} · ${usuario.nombreCompleto}',
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 20),
                        ResumenCuentaSection(usuario: usuario),
                        const SizedBox(height: 24),
                        FormularioRecarga(saldoDisponible: usuario.saldo),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
