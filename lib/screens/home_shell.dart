import 'package:flutter/material.dart';

import '../widgets/app_bottom_bar.dart';
import '../widgets/app_header.dart';
import 'mercado_screen.dart';
import 'operaciones_screen.dart';

/// Pantalla principal: cabecera con logo + contenido + barra inferior.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // En el diseño la pestaña activa es "Operaciones".
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const AppHeader(),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: const <Widget>[
                MercadoScreen(),
                OperacionesScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        index: _index,
        onChanged: (int i) => setState(() => _index = i),
      ),
    );
  }
}
