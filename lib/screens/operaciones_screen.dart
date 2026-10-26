import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/operation_card.dart';
import '../widgets/section_widgets.dart';
import 'calculo_ley_screen.dart';
import 'recibo_screen.dart';

/// Pestaña "Operaciones": lista de cálculos disponibles (mismo estilo del diseño).
class OperacionesScreen extends StatelessWidget {
  const OperacionesScreen({super.key});

  void _openLey(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CalculoLeyScreen()),
    );
  }

  void _openRecibo(BuildContext context) {
    final AppState app = AppScope.of(context);
    final data = app.ultimoRecibo;
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero realice un cálculo de ley y genere el recibo.'),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ReciboScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 0),
          child: SectionLabel('Operaciones'),
        ),
        const SizedBox(height: 14),
        OperationCard(
          title: 'Cálculo de ley',
          subtitle: 'Calcular ley, finos y total a pagar',
          icon: Icons.landscape,
          onTap: () => _openLey(context),
        ),
        const SizedBox(height: 12),
        OperationCard(
          title: 'Recibo de pago',
          subtitle: 'Ver el recibo del último cálculo',
          icon: Icons.receipt_long,
          onTap: () => _openRecibo(context),
        ),
      ],
    );
  }
}
