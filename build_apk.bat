@echo off
echo ========================================
echo    MARIO TOUCH ADVENTURE - APK BUILDER
echo ========================================
echo.

echo [1/5] Verificando Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter no encontrado. Instalando...
    echo.
    echo Descargando Flutter...
    powershell -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip' -OutFile 'flutter.zip'"
    
    echo.
    echo Extrayendo Flutter...
    powershell -Command "Expand-Archive -Path 'flutter.zip' -DestinationPath 'C:\' -Force"
    
    echo.
    echo Configurando PATH...
    setx PATH "%PATH%;C:\flutter\bin"
    
    echo.
    echo Limpiando archivos temporales...
    del flutter.zip
    
    echo Flutter instalado exitosamente!
) else (
    echo Flutter ya está instalado.
)

echo.
echo [2/5] Verificando dependencias...
flutter doctor

echo.
echo [3/5] Instalando dependencias del proyecto...
flutter pub get

echo.
echo [4/5] Limpiando build anterior...
flutter clean

echo.
echo [5/5] Generando APK de release...
flutter build apk --release

echo.
echo ========================================
echo ¡APK GENERADO EXITOSAMENTE!
echo ========================================
echo.
echo El APK se encuentra en:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Presiona cualquier tecla para abrir la carpeta...
pause >nul
explorer build\app\outputs\flutter-apk\
