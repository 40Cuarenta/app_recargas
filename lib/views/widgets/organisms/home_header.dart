import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '../molecules/user_header.dart';

/// Organismo: Cabecera superior de la Pantalla Principal.
/// Presenta el isotipo de marca, el saludo corporativo ("Bienvenido,")
/// y el nombre completo del usuario autenticado.
/// Reutiliza la molécula [UserHeader].
class HomeHeader extends StatelessWidget {
  /// Datos del usuario activo en la sesión.
  final Usuario usuario;

  /// Acción secundaria opcional en la esquina derecha (ej. información o ayuda).
  final VoidCallback? onInfoTap;

  const HomeHeader({
    super.key,
    required this.usuario,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return UserHeader(
      nombreUsuario: usuario.nombreCompleto,
      subtitulo: '@${usuario.nombreUsuario} • Terminal POS',
      logoSize: 52.0,
      trailing: onInfoTap != null
          ? IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: onInfoTap,
              tooltip: 'Información del punto de venta',
            )
          : null,
    );
  }
}

