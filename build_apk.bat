@echo off
REM Genera el APK de Oro Andino (Windows). Requiere Flutter en el PATH.
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo ERROR: Flutter no esta en el PATH. Instalelo desde https://docs.flutter.dev/get-started/install
  exit /b 1
)

if not exist android (
  call flutter create --platforms=android --org com.oroandino --project-name oro_andino .
  if errorlevel 1 exit /b 1
)
if exist test\widget_test.dart del test\widget_test.dart

REM Nombre visible e icono
powershell -NoProfile -Command "(Get-Content 'android\app\src\main\AndroidManifest.xml') -replace 'android:label=\"[^\"]*\"','android:label=\"Oro Andino\"' | Set-Content 'android\app\src\main\AndroidManifest.xml'"
for %%d in (mdpi hdpi xhdpi xxhdpi xxxhdpi) do (
  if not exist "android\app\src\main\res\mipmap-%%d" mkdir "android\app\src\main\res\mipmap-%%d"
  copy /Y "assets\launcher\mipmap-%%d\ic_launcher.png" "android\app\src\main\res\mipmap-%%d\ic_launcher.png" >nul
)

call flutter pub get || exit /b 1
call flutter test || exit /b 1
call flutter build apk --release || exit /b 1

echo.
echo APK generado en: build\app\outputs\flutter-apk\app-release.apk
