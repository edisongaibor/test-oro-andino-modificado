# Oro Andino – Calculadora de ley

App Flutter (Android) basada en el diseño de referencia y en las fórmulas de `CALCULO_LEY_USB.xls`.

## Fórmulas (hoja "CALCULO LEY")

| Concepto | Fórmula |
|---|---|
| Diferencia | `PS − PH` |
| Memoria | `PS ÷ Diferencia` |
| Ley | `−((Fórmula fija 1 ÷ Memoria) − Fórmula fija 2)` |
| Finos | `Ley × PS` |
| Precio por gramo | `Base × Ley` |
| Total a pagar | `Base × Finos` |

Valores por defecto (editables): Fórmula fija 1 = 23.03, Fórmula fija 2 = 2.192, Base = 117.
La pestaña **Mercado** guarda la **Onza** y la **Fecha** que se imprimen en el **Recibo de pago**.

## Generar el APK

Con Flutter instalado (`flutter doctor` sin errores):

- Windows: doble clic en `build_apk.bat`
- Linux / macOS: `bash build_apk.sh`

Resultado: `build/app/outputs/flutter-apk/app-release.apk`

Sin instalar nada: suba esta carpeta a un repositorio de GitHub; el flujo
`.github/workflows/build-apk.yml` compila el APK y lo deja en *Actions → Artifacts*.

## Estructura

```
lib/
  main.dart                  arranque y tema
  core/                      colores, tema, formateo de números
  logic/ley_calculator.dart  fórmulas del Excel (lógica pura, con pruebas)
  state/app_state.dart       onza, fecha y último recibo
  widgets/                   logo, cabecera, tarjetas, barra inferior, campos
  screens/                   inicio, mercado, operaciones, cálculo de ley, recibo
test/ley_calculator_test.dart  valida contra los resultados del Excel
```
