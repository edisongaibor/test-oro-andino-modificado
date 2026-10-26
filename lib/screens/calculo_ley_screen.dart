import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../logic/ley_calculator.dart';
import '../state/app_state.dart';
import '../widgets/app_header.dart';
import '../widgets/number_field.dart';
import '../widgets/section_widgets.dart';
import 'recibo_screen.dart';

/// Calculadora de ley: replica la hoja "CALCULO LEY" del Excel.
class CalculoLeyScreen extends StatefulWidget {
  const CalculoLeyScreen({super.key});

  @override
  State<CalculoLeyScreen> createState() => _CalculoLeyScreenState();
}

class _CalculoLeyScreenState extends State<CalculoLeyScreen> {
  final TextEditingController _ps = TextEditingController();
  final TextEditingController _ph = TextEditingController();
  final TextEditingController _f1 =
      TextEditingController(text: kFormulaFija1Default.toString());
  final TextEditingController _f2 =
      TextEditingController(text: kFormulaFija2Default.toString());
  final TextEditingController _base =
      TextEditingController(text: kBaseDefault.toStringAsFixed(0));

  /// null = aún faltan datos por ingresar.
  LeyOutcome? _outcome;

  @override
  void dispose() {
    _ps.dispose();
    _ph.dispose();
    _f1.dispose();
    _f2.dispose();
    _base.dispose();
    super.dispose();
  }

  void _recalculate() {
    final double? ps = parseDecimal(_ps.text);
    final double? ph = parseDecimal(_ph.text);
    final double? f1 = parseDecimal(_f1.text);
    final double? f2 = parseDecimal(_f2.text);
    final double? base = parseDecimal(_base.text);

    LeyOutcome? outcome;
    if (ps == null || ph == null) {
      outcome = null;
    } else if (f1 == null || f2 == null || base == null) {
      outcome = const LeyOutcome.failure(
        'Complete la fórmula fija 1, la fórmula fija 2 y la base.',
      );
    } else {
      outcome = LeyCalculator.calculate(
        gramosPs: ps,
        gramosPh: ph,
        formulaFija1: f1,
        formulaFija2: f2,
        base: base,
      );
    }
    setState(() => _outcome = outcome);
  }

  void _clear() {
    _ps.clear();
    _ph.clear();
    _f1.text = kFormulaFija1Default.toString();
    _f2.text = kFormulaFija2Default.toString();
    _base.text = kBaseDefault.toStringAsFixed(0);
    FocusScope.of(context).unfocus();
    _recalculate();
  }

  void _openRecibo() {
    final LeyResult? result = _outcome?.result;
    final double? ps = parseDecimal(_ps.text);
    final double? ph = parseDecimal(_ph.text);
    final double? base = parseDecimal(_base.text);
    if (result == null || ps == null || ph == null || base == null) return;

    final AppState app = AppScope.of(context);
    final ReciboData data = ReciboData(
      fecha: app.fecha,
      onza: app.onza,
      gramosPs: ps,
      gramosPh: ph,
      base: base,
      result: result,
    );
    app.setUltimoRecibo(data);
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ReciboScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LeyResult? result = _outcome?.result;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            AppHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                children: <Widget>[
                  const SectionLabel('Cálculo de ley'),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Datos de la muestra',
                    subtitle: 'Pesos obtenidos en balanza',
                    child: Column(
                      children: <Widget>[
                        NumberField(
                          controller: _ps,
                          label: 'Gramos PS',
                          hint: 'Ej. 58.36',
                          suffix: 'g',
                          onChanged: (_) => _recalculate(),
                        ),
                        const SizedBox(height: 14),
                        NumberField(
                          controller: _ph,
                          label: 'Gramos PH',
                          hint: 'Ej. 54.77',
                          suffix: 'g',
                          onChanged: (_) => _recalculate(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SectionCard(
                    title: 'Constantes y base',
                    subtitle: 'Valores del Excel; puede modificarlos',
                    child: Column(
                      children: <Widget>[
                        NumberField(
                          controller: _f1,
                          label: 'Fórmula fija 1',
                          onChanged: (_) => _recalculate(),
                        ),
                        const SizedBox(height: 14),
                        NumberField(
                          controller: _f2,
                          label: 'Fórmula fija 2',
                          onChanged: (_) => _recalculate(),
                        ),
                        const SizedBox(height: 14),
                        NumberField(
                          controller: _base,
                          label: 'Base',
                          prefix: '\$ ',
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => _recalculate(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildResults(result),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _clear,
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text('Limpiar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            minimumSize: const Size.fromHeight(50),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: FilledButton.icon(
                          onPressed: result == null ? null : _openRecibo,
                          icon: const Icon(Icons.receipt_long, size: 20),
                          label: const Text('Generar recibo'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.ink,
                            disabledBackgroundColor: AppColors.border,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(LeyResult? result) {
    final String? error = _outcome?.error;

    if (error != null) {
      return MessageBanner(message: error);
    }
    if (result == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: <Widget>[
            Icon(Icons.info_outline, size: 20, color: AppColors.subtle),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Ingrese Gramos PS y Gramos PH para ver el resultado.',
                style: TextStyle(fontSize: 13, color: AppColors.subtle),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionCard(
          title: 'Resultado',
          child: Column(
            children: <Widget>[
              ResultRow(
                label: 'Diferencia',
                note: 'PS − PH',
                value: '${formatNumber(result.diferencia, decimals: 2)} g',
              ),
              const Divider(height: 1, color: AppColors.border),
              ResultRow(
                label: 'Memoria',
                note: 'PS ÷ diferencia',
                value: formatNumber(result.memoria, decimals: 4),
              ),
              const Divider(height: 1, color: AppColors.border),
              ResultRow(
                label: 'Ley',
                note: '${formatNumber(result.ley * 100, decimals: 2)} %',
                value: formatNumber(result.ley, decimals: 4, grouping: false),
              ),
              const Divider(height: 1, color: AppColors.border),
              ResultRow(
                label: 'Finos',
                note: 'Ley × PS',
                value: '${formatNumber(result.finos, decimals: 4)} g',
              ),
              const Divider(height: 1, color: AppColors.border),
              ResultRow(
                label: 'Precio por gramo',
                note: 'Base × ley',
                value: formatMoney(result.precioPorGramo),
              ),
            ],
          ),
        ),
        if (result.leyFueraDeRango) ...<Widget>[
          const SizedBox(height: 10),
          const MessageBanner(
            isError: false,
            message: 'La ley está fuera del rango 0–1. '
                'Revise los pesos y las fórmulas fijas.',
          ),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'TOTAL A PAGAR',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatMoney(result.totalAPagar),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Text(
                'Base × finos',
                style: TextStyle(fontSize: 11.5, color: AppColors.ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
