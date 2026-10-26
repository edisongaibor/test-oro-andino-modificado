import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Barra inferior con dos pestañas: Mercado y Operaciones.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  static const List<_Item> _items = <_Item>[
    _Item('Mercado', Icons.bar_chart_rounded),
    _Item('Operaciones', Icons.calculate),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List<Widget>.generate(_items.length, (int i) {
              final bool selected = i == index;
              final Color color = selected ? AppColors.gold : AppColors.ink;
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(_items[i].icon, size: 26, color: color),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Item {
  const _Item(this.label, this.icon);
  final String label;
  final IconData icon;
}
