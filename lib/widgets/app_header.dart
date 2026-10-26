import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'oro_andino_logo.dart';

/// Cabecera dorada con el logo. En la pantalla principal es alta (como en el
/// diseño); en las pantallas internas es compacta y lleva botón de regreso.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.of(context).padding.top;

    if (onBack == null) {
      return Container(
        width: double.infinity,
        height: top + 92,
        color: AppColors.gold,
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
        child: const OroAndinoLogo(height: 26),
      );
    }

    return Container(
      width: double.infinity,
      color: AppColors.gold,
      padding: EdgeInsets.fromLTRB(4, top + 6, 20, 10),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            tooltip: 'Volver',
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
          const Spacer(),
          const OroAndinoLogo(height: 22),
        ],
      ),
    );
  }
}
