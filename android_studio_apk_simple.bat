@echo off
echo ========================================
echo    MARIO TOUCH ADVENTURE - ANDROID STUDIO
echo ========================================
echo.

echo [1/4] Abriendo Android Studio...
start "" "C:\Program Files\Android\Android Studio1\bin\studio64.exe" "D:\mario_touch_adventure"

echo.
echo [2/4] Esperando que Android Studio se abra...
timeout /t 10 /nobreak >nul

echo.
echo [3/4] INSTRUCCIONES PARA GENERAR EL APK:
echo.
echo 1. En Android Studio, espera a que el proyecto se sincronice
echo 2. Ve a Build > Build Bundle(s) / APK(s) > Build APK(s)
echo 3. O usa el atajo: Ctrl + Shift + F9
echo 4. Espera a que termine la compilacion
echo 5. El APK estara en: build\app\outputs\flutter-apk\
echo.

echo [4/4] Abriendo la carpeta de salida...
timeout /t 5 /nobreak >nul
explorer "D:\mario_touch_adventure\build\app\outputs\flutter-apk"

echo.
echo ========================================
echo ¡PROCESO COMPLETADO!
echo ========================================
echo.
echo El APK se generara en:
echo D:\mario_touch_adventure\build\app\outputs\flutter-apk\
echo.
echo CARACTERISTICAS DEL JUEGO MEJORADO:
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
echo Presiona cualquier tecla para continuar...
pause >nul
