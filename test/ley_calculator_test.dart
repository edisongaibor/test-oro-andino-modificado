import 'package:flutter_test/flutter_test.dart';
import 'package:oro_andino/core/formatters.dart';
import 'package:oro_andino/logic/ley_calculator.dart';

void main() {
  group('LeyCalculator (valores del Excel CALCULO_LEY_USB.xls)', () {
    test('caso exitoso: PS 58.36, PH 54.77, base 117', () {
      final LeyOutcome o = LeyCalculator.calculate(
        gramosPs: 58.36,
        gramosPh: 54.77,
        formulaFija1: 23.03,
        formulaFija2: 2.192,
        base: 117,
      );
      expect(o.isSuccess, isTrue);
      final LeyResult r = o.result!;
      expect(r.diferencia, closeTo(3.59, 1e-9));
      expect(r.memoria, closeTo(16.2562674094708, 1e-9));
      expect(r.ley, closeTo(0.77531562714188, 1e-9));
      expect(r.finos, closeTo(45.24742, 1e-6));
      expect(r.precioPorGramo, closeTo(90.7119283755999, 1e-6));
      expect(r.totalAPagar, closeTo(5293.94814, 1e-4));
      expect(r.leyFueraDeRango, isFalse);
    });

    test('PS igual a PH -> error (diferencia cero)', () {
      final LeyOutcome o = LeyCalculator.calculate(
        gramosPs: 50,
        gramosPh: 50,
        formulaFija1: 23.03,
        formulaFija2: 2.192,
        base: 117,
      );
      expect(o.isSuccess, isFalse);
      expect(o.error, isNotNull);
    });

    test('PS menor que PH -> error', () {
      final LeyOutcome o = LeyCalculator.calculate(
        gramosPs: 40,
        gramosPh: 50,
        formulaFija1: 23.03,
        formulaFija2: 2.192,
        base: 117,
      );
      expect(o.isSuccess, isFalse);
    });

    test('valores cero o negativos -> error', () {
      expect(
        LeyCalculator.calculate(
          gramosPs: 0,
          gramosPh: 0,
          formulaFija1: 23.03,
          formulaFija2: 2.192,
          base: 117,
        ).isSuccess,
        isFalse,
      );
      expect(
        LeyCalculator.calculate(
          gramosPs: 58,
          gramosPh: -1,
          formulaFija1: 23.03,
          formulaFija2: 2.192,
          base: 117,
        ).isSuccess,
        isFalse,
      );
      expect(
        LeyCalculator.calculate(
          gramosPs: 58,
          gramosPh: 54,
          formulaFija1: 23.03,
          formulaFija2: 2.192,
          base: -5,
        ).isSuccess,
        isFalse,
      );
    });

    test('base 0 -> precio y total en 0', () {
      final LeyResult r = LeyCalculator.calculate(
        gramosPs: 58.36,
        gramosPh: 54.77,
        formulaFija1: 23.03,
        formulaFija2: 2.192,
        base: 0,
      ).result!;
      expect(r.precioPorGramo, 0);
      expect(r.totalAPagar, 0);
    });

    test('datos que dan ley fuera de rango activan la advertencia', () {
      // Diferencia muy pequeña -> memoria enorme -> ley ~ 2.192 (> 1)
      final LeyResult r = LeyCalculator.calculate(
        gramosPs: 100,
        gramosPh: 99.9,
        formulaFija1: 23.03,
        formulaFija2: 2.192,
        base: 117,
      ).result!;
      expect(r.leyFueraDeRango, isTrue);
    });
  });

  group('Formateadores', () {
    test('parseDecimal acepta coma y punto', () {
      expect(parseDecimal('58.36'), 58.36);
      expect(parseDecimal('58,36'), 58.36);
      expect(parseDecimal('  7 '), 7);
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('.'), isNull);
      expect(parseDecimal('1.2.3'), isNull);
    });

    test('formatNumber agrupa miles y redondea', () {
      expect(formatNumber(5293.94814), '5,293.95');
      expect(formatNumber(1234567.891), '1,234,567.89');
      expect(formatNumber(999.999), '1,000.00');
      expect(formatNumber(0.775315, decimals: 4, grouping: false), '0.7753');
      expect(formatNumber(-12.5), '-12.50');
      expect(formatNumber(-0.001), '0.00');
      expect(formatNumber(double.nan), '—');
    });

    test('formatMoney y formatDate', () {
      expect(formatMoney(117), '\$ 117.00');
      expect(formatDate(DateTime(2024, 7, 8)), '08/07/2024');
    });
  });
}
