@echo off
echo ========================================
echo 🎮 Mario Touch Adventure - Generador de APK
echo ========================================
echo.

echo 📱 Iniciando generación del APK...
echo.

REM Verificar si Flutter está instalado
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter no está instalado o no está en el PATH
    echo.
    echo 🔧 Instalando Flutter...
    choco install flutter -y
    echo.
    echo 🔄 Refrescando variables de entorno...
    refreshenv
    echo.
)

echo ✅ Flutter detectado correctamente
echo.

echo 📦 Instalando dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Error al instalar dependencias
    pause
    exit /b 1
)
echo ✅ Dependencias instaladas correctamente
echo.

echo 🔨 Generando APK de release...
flutter build apk --release
if %errorlevel% neq 0 (
    echo ❌ Error al generar el APK
    pause
    exit /b 1
)
echo.

echo ✅ ¡APK generado exitosamente!
echo.
echo 📍 Ubicación del APK:
echo    build\app\outputs\flutter-apk\app-release.apk
echo.

echo 🎮 Características del juego mejorado:
echo    ✅ Motor de Física Realista
echo    ✅ Sistema de Audio Profesional  
echo    ✅ UI/UX Mejorado con Animaciones
echo    ✅ Sistema de Guardado Avanzado
echo    ✅ Controles Táctiles con Haptic Feedback
echo    ✅ Efectos Visuales y Partículas
echo    ✅ Sistema de Logros y Estadísticas
echo    ✅ Configuraciones Personalizables
echo    ✅ Optimización de Rendimiento
echo.

echo 📱 Para instalar en Android:
echo    1. Habilitar fuentes desconocidas en Configuración > Seguridad
echo    2. Copiar el APK a tu dispositivo Android
echo    3. Tocar en el archivo APK para instalar
echo    4. ¡Disfrutar del juego mejorado!
echo.

echo 🚀 ¡Tu Mario Touch Adventure ahora es completamente profesional!
echo.

pause
