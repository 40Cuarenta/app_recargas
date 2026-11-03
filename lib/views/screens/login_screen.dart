import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/atoms/app_chip_option.dart';
import '../widgets/atoms/app_label.dart';
import '../widgets/atoms/app_logo.dart';
import '../widgets/atoms/app_title.dart';
import '../widgets/organisms/login_form.dart';

/// Pantalla 1: Inicio de Sesión (Mockup 1).
/// Permite al operador identificarse en el terminal de recargas.
/// Si la autenticación falla, notifica mediante [SnackBar] y banner reactivo.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController(text: 'cajero1');
  final _contrasenaController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final exito = await authController.login(
      _usuarioController.text,
      _contrasenaController.text,
    );

    if (!mounted) return;

    if (exito) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.error ?? 'Error de autenticación.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Isotipo de marca destacado
                  const AppLogo(
                    size: 88,
                    borderRadius: 24,
                  ),
                  const SizedBox(height: 16),

                  // Título principal de la aplicación
                  const AppTitle(
                    text: 'Recargas Ecuador',
                    size: AppTitleSize.grande,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const AppLabel(
                    text: 'Terminal de Operaciones Prepago',
                    variant: AppLabelVariant.subtitulo,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Tarjeta contenedora con el organismo de login
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: LoginForm(
                        formKey: _formKey,
                        usuarioController: _usuarioController,
                        contrasenaController: _contrasenaController,
                        isLoading: authController.cargando,
                        errorMessage: authController.error,
                        onSubmit: _iniciarSesion,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Credenciales rápidas de prueba
                  const AppLabel(
                    text: 'Acceso rápido de prueba:',
                    variant: AppLabelVariant.pequena,
                    color: AppColors.textoSecundario,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      AppChipOption(
                        label: 'cajero1 (123456)',
                        isSelected: _usuarioController.text == 'cajero1',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        onTap: () {
                          setState(() {
                            _usuarioController.text = 'cajero1';
                            _contrasenaController.text = '123456';
                          });
                        },
                      ),
                      AppChipOption(
                        label: 'admin (admin123)',
                        isSelected: _usuarioController.text == 'admin',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        onTap: () {
                          setState(() {
                            _usuarioController.text = 'admin';
                            _contrasenaController.text = 'admin123';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


