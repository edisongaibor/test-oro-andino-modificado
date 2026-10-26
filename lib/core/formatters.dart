/// Convierte texto a número aceptando coma o punto como separador decimal.
/// Devuelve `null` si el texto está vacío o no es un número válido.
double? parseDecimal(String text) {
  final String t = text.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  final double? value = double.tryParse(t);
  if (value == null || value.isNaN || value.isInfinite) return null;
  return value;
}

/// Formatea un número con [decimals] decimales y separador de miles.
/// Ejemplo: 5293.94814 -> "5,293.95"
String formatNumber(double value, {int decimals = 2, bool grouping = true}) {
  if (value.isNaN || value.isInfinite) return '—';
  final String fixed = value.abs().toStringAsFixed(decimals);
  final List<String> parts = fixed.split('.');
  String intPart = parts[0];

  if (grouping) {
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final int fromEnd = intPart.length - i;
      buffer.write(intPart[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
    }
    intPart = buffer.toString();
  }

  final bool isZero = double.parse(fixed) == 0;
  final String sign = (value < 0 && !isZero) ? '-' : '';
  return decimals > 0 ? '$sign$intPart.${parts[1]}' : '$sign$intPart';
}

/// Formato de dinero: "$ 5,293.95".
String formatMoney(double value, {int decimals = 2}) =>
    '\$ ${formatNumber(value, decimals: decimals)}';

/// Fecha en formato dd/MM/yyyy.
String formatDate(DateTime date) {
  final String d = date.day.toString().padLeft(2, '0');
  final String m = date.month.toString().padLeft(2, '0');
  return '$d/$m/${date.year}';
}
