import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../logic/ley_calculator.dart';
import '../widgets/app_header.dart';
import '../widgets/section_widgets.dart';

/// Recibo de pago: replica la hoja "RECIBO DE PAGO" del Excel.
class ReciboScreen extends StatelessWidget {
  const ReciboScreen({super.key, required this.data});

  final ReciboData data;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data.toPlainText()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recibo copiado al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LeyResult r = data.result;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          AppHeader(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: <Widget>[
                const SectionLabel('Recibo de pago'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'CÁLCULO DE LEY',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Center(
                        child: Text(
                          'RECIBO DE PAGO',
                          style: TextStyle(
                            fontSize: 12.5,
                            letterSpacing: 1.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.border),
                      ResultRow(label: 'Fecha', value: formatDate(data.fecha)),
                      ResultRow(
                        label: 'Gramos PS',
                        value: '${formatNumber(data.gramosPs)} g',
                      ),
                      ResultRow(
                        label: 'Gramos PH',
                        value: '${formatNumber(data.gramosPh)} g',
                      ),
                      ResultRow(
                        label: 'Ley',
                        value: formatNumber(
                          r.ley,
                          decimals: 4,
                          grouping: false,
                        ),
                      ),
                      ResultRow(
                        label: 'Finos',
                        value: '${formatNumber(r.finos, decimals: 4)} g',
                      ),
                      ResultRow(
                        label: 'Onza',
                        value: data.onza == null
                            ? '—'
                            : formatMoney(data.onza!),
                      ),
                      ResultRow(label: 'Base', value: formatMoney(data.base)),
                      ResultRow(
                        label: 'Precio por gramo',
                        value: formatMoney(r.precioPorGramo),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.goldSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: Text(
                                'TOTAL A PAGAR',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            Text(
                              formatMoney(r.totalAPagar),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 56),
                      const Center(
                        child: SizedBox(
                          width: 180,
                          child: Divider(height: 1, color: AppColors.ink),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'FIRMA',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => _copy(context),
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  label: const Text('Copiar recibo'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.ink,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
