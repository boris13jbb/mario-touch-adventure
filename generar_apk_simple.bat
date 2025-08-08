@echo off
echo ========================================
echo 🎮 Mario Touch Adventure - APK Simple
echo ========================================
echo.

echo 📱 Generando APK con configuración simple...
echo.

REM Verificar Flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter no está disponible
    echo 🔧 Instalando Flutter...
    choco install flutter -y
    refreshenv
)

echo ✅ Flutter detectado
echo.

REM Limpiar proyecto
echo 🧹 Limpiando proyecto...
flutter clean

REM Instalar dependencias básicas
echo 📦 Instalando dependencias...
flutter pub get

REM Generar APK con configuración simple
echo 🔨 Generando APK...
flutter build apk --release --android-skip-build-dependency-validation

if %errorlevel% equ 0 (
    echo.
    echo ✅ ¡APK generado exitosamente!
    echo.
    echo 📍 Ubicación: build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 🎮 Características del juego:
    echo    ✅ Motor de Física Realista
    echo    ✅ Sistema de Audio Profesional
    echo    ✅ UI/UX Mejorado
    echo    ✅ Sistema de Guardado
    echo    ✅ Controles Táctiles
    echo    ✅ Efectos Visuales
    echo    ✅ Sistema de Logros
    echo.
    echo 📱 Para instalar:
    echo    1. Habilitar fuentes desconocidas
    echo    2. Copiar APK a tu dispositivo
    echo    3. Instalar y disfrutar
    echo.
    
    REM Abrir carpeta del APK
    if exist "build\app\outputs\flutter-apk\" (
        echo 🔍 Abriendo carpeta del APK...
        start "" "build\app\outputs\flutter-apk\"
    )
) else (
    echo.
    echo ❌ Error al generar APK
    echo 💡 Intenta con: flutter doctor
)

echo.
pause
