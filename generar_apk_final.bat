@echo off
echo ========================================
echo    MARIO TOUCH ADVENTURE - GENERAR APK
echo ========================================
echo.

echo [1/4] Limpiando proyecto...
flutter clean

echo.
echo [2/4] Obteniendo dependencias...
flutter pub get

echo.
echo [3/4] Generando APK de release...
flutter build apk --release

echo.
echo [4/4] APK generado exitosamente!
echo.
echo El APK se encuentra en:
echo D:\mario_touch_adventure\build\app\outputs\flutter-apk\app-release.apk
echo.
echo CARACTERISTICAS DEL JUEGO:
echo - Motor de Fisica Realista
echo - Sistema de Audio Profesional
echo - UI/UX Mejorado con Animaciones
echo - Sistema de Guardado Avanzado
echo - Controles Tactiles con Haptic Feedback
echo - Efectos Visuales y Particulas
echo - Sistema de Logros y Estadisticas
echo - Configuraciones Personalizables
echo - Optimizacion de Rendimiento
echo.
echo Presiona cualquier tecla para abrir la carpeta...
pause >nul
explorer "D:\mario_touch_adventure\build\app\outputs\flutter-apk"
