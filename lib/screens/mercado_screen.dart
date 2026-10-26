import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/number_field.dart';
import '../widgets/section_widgets.dart';

/// Pestaña "Mercado": datos de mercado que se imprimen en el recibo
/// (precio de la onza y fecha), como en la hoja "RECIBO DE PAGO".
class MercadoScreen extends StatefulWidget {
  const MercadoScreen({super.key});

  @override
  State<MercadoScreen> createState() => _MercadoScreenState();
}

class _MercadoScreenState extends State<MercadoScreen> {
  final TextEditingController _onza = TextEditingController();

  @override
  void dispose() {
    _onza.dispose();
    super.dispose();
  }

  Future<void> _pickDate(AppState app) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: app.fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) app.setFecha(picked);
  }

  @override
  Widget build(BuildContext context) {
    final AppState app = AppScope.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: <Widget>[
          const SectionLabel('Mercado'),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Precio de la onza',
            subtitle: 'Se mostrará en el recibo de pago',
            child: NumberField(
              controller: _onza,
              label: 'Onza',
              hint: 'Ej. 2373',
              prefix: '\$ ',
              textInputAction: TextInputAction.done,
              onChanged: (String v) => app.setOnza(parseDecimal(v)),
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Fecha',
            subtitle: 'Fecha del recibo de pago',
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _pickDate(app),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: AppColors.goldDark,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatDate(app.fecha),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Cambiar',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
