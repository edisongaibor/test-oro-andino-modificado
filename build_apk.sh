#!/usr/bin/env bash
# Genera el APK de Oro Andino (Linux / macOS / Git Bash).
# Requisitos: Flutter SDK en el PATH y Android SDK configurado (flutter doctor).
set -euo pipefail
cd "$(dirname "$0")"

command -v flutter >/dev/null 2>&1 || {
  echo "ERROR: Flutter no está en el PATH. Instálelo desde https://docs.flutter.dev/get-started/install"
  exit 1
}

# 1) Crear la carpeta android/ (solo la primera vez). No sobrescribe lib/ ni pubspec.yaml.
if [ ! -d android ]; then
  flutter create --platforms=android --org com.oroandino --project-name oro_andino .
fi
rm -f test/widget_test.dart

# 2) Nombre visible e ícono de la app
sed -i.bak 's/android:label="[^"]*"/android:label="Oro Andino"/' android/app/src/main/AndroidManifest.xml
rm -f android/app/src/main/AndroidManifest.xml.bak
for d in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  mkdir -p "android/app/src/main/res/mipmap-$d"
  cp "assets/launcher/mipmap-$d/ic_launcher.png" "android/app/src/main/res/mipmap-$d/ic_launcher.png"
done

# 3) Dependencias, pruebas y APK
flutter pub get
flutter test
flutter build apk --release

echo
echo "APK generado en: build/app/outputs/flutter-apk/app-release.apk"
