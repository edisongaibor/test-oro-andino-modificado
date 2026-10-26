import 'package:flutter/widgets.dart';

import '../logic/ley_calculator.dart';

/// Estado compartido entre pantallas: datos de mercado y último recibo.
class AppState extends ChangeNotifier {
  DateTime _fecha = DateTime.now();
  double? _onza;
  ReciboData? _ultimoRecibo;

  DateTime get fecha => _fecha;
  double? get onza => _onza;
  ReciboData? get ultimoRecibo => _ultimoRecibo;

  void setFecha(DateTime value) {
    _fecha = value;
    notifyListeners();
  }

  void setOnza(double? value) {
    _onza = value;
    notifyListeners();
  }

  void setUltimoRecibo(ReciboData value) {
    _ultimoRecibo = value;
    notifyListeners();
  }
}

/// Expone [AppState] a todo el árbol de widgets.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No se encontró AppScope en el árbol de widgets');
    return scope!.notifier!;
  }
}
