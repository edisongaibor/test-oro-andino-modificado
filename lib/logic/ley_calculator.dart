import '../core/formatters.dart';

/// Valores por defecto tomados del Excel (CALCULO_LEY_USB.xls).
const double kFormulaFija1Default = 23.03;
const double kFormulaFija2Default = 2.192;
const double kBaseDefault = 117;

/// Resultado del cálculo de ley (hoja "CALCULO LEY" del Excel).
class LeyResult {
  const LeyResult({
    required this.diferencia,
    required this.memoria,
    required this.ley,
    required this.finos,
    required this.precioPorGramo,
    required this.totalAPagar,
  });

  /// C4 = PS - PH
  final double diferencia;

  /// D4 = PS / DIFERENCIA
  final double memoria;

  /// G4 = -((FORMULA_FIJA_1 / MEMORIA) - FORMULA_FIJA_2)
  final double ley;

  /// H4 = LEY * PS
  final double finos;

  /// J4 = BASE * LEY
  final double precioPorGramo;

  /// K4 = BASE * FINOS
  final double totalAPagar;

  /// La ley es una fracción entre 0 y 1; fuera de ese rango hay un dato dudoso.
  bool get leyFueraDeRango => ley < 0 || ley > 1;
}

/// Resultado de una validación + cálculo: o bien [result] o bien [error].
class LeyOutcome {
  const LeyOutcome.success(this.result) : error = null;
  const LeyOutcome.failure(this.error) : result = null;

  final LeyResult? result;
  final String? error;

  bool get isSuccess => result != null;
}

class LeyCalculator {
  LeyCalculator._();

  /// Reproduce exactamente las fórmulas de la hoja "CALCULO LEY".
  static LeyOutcome calculate({
    required double gramosPs,
    required double gramosPh,
    required double formulaFija1,
    required double formulaFija2,
    required double base,
  }) {
    if (gramosPs <= 0) {
      return const LeyOutcome.failure('Los gramos PS deben ser mayores que 0.');
    }
    if (gramosPh <= 0) {
      return const LeyOutcome.failure('Los gramos PH deben ser mayores que 0.');
    }
    if (gramosPs <= gramosPh) {
      return const LeyOutcome.failure(
        'Los gramos PS deben ser mayores que los gramos PH '
        '(la diferencia debe ser positiva).',
      );
    }
    if (base < 0) {
      return const LeyOutcome.failure('La base no puede ser negativa.');
    }

    final double diferencia = gramosPs - gramosPh; // C4
    final double memoria = gramosPs / diferencia; // D4
    final double ley = -((formulaFija1 / memoria) - formulaFija2); // G4
    final double finos = ley * gramosPs; // H4
    final double precioPorGramo = base * ley; // J4
    final double total = base * finos; // K4

    return LeyOutcome.success(
      LeyResult(
        diferencia: diferencia,
        memoria: memoria,
        ley: ley,
        finos: finos,
        precioPorGramo: precioPorGramo,
        totalAPagar: total,
      ),
    );
  }
}

/// Datos completos para el recibo de pago (hoja "RECIBO DE PAGO").
class ReciboData {
  const ReciboData({
    required this.fecha,
    required this.onza,
    required this.gramosPs,
    required this.gramosPh,
    required this.base,
    required this.result,
  });

  final DateTime fecha;
  final double? onza;
  final double gramosPs;
  final double gramosPh;
  final double base;
  final LeyResult result;

  String toPlainText() {
    final StringBuffer b = StringBuffer()
      ..writeln('ORO ANDINO')
      ..writeln('CÁLCULO DE LEY - RECIBO DE PAGO')
      ..writeln('--------------------------------')
      ..writeln('FECHA: ${formatDate(fecha)}')
      ..writeln('GRAMOS PS: ${formatNumber(gramosPs, decimals: 2)}')
      ..writeln('GRAMOS PH: ${formatNumber(gramosPh, decimals: 2)}')
      ..writeln('LEY: ${formatNumber(result.ley, decimals: 4, grouping: false)}')
      ..writeln('FINOS: ${formatNumber(result.finos, decimals: 4)}')
      ..writeln('ONZA: ${onza == null ? '—' : formatMoney(onza!)}')
      ..writeln('BASE: ${formatMoney(base)}')
      ..writeln('PRECIO POR GRAMO: ${formatMoney(result.precioPorGramo)}')
      ..writeln('TOTAL A PAGAR: ${formatMoney(result.totalAPagar)}');
    return b.toString();
  }
}
