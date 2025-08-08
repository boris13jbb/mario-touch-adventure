# Mario Touch Adventure - APK Builder
# Script PowerShell para generar el APK del juego mejorado

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   MARIO TOUCH ADVENTURE - APK BUILDER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar si Flutter está instalado
function Test-FlutterInstalled {
    try {
        $flutterVersion = flutter --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

# Función para instalar Flutter
function Install-Flutter {
    Write-Host "[1/5] Instalando Flutter..." -ForegroundColor Yellow
    
    $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip"
    $flutterZip = "flutter.zip"
    $flutterPath = "C:\flutter"
    
    Write-Host "Descargando Flutter..." -ForegroundColor Green
    try {
        Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing
        Write-Host "Descarga completada!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al descargar Flutter: $_" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Extrayendo Flutter..." -ForegroundColor Green
    try {
        Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
        Write-Host "Extracción completada!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al extraer Flutter: $_" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Configurando PATH..." -ForegroundColor Green
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($currentPath -notlike "*flutter*") {
            $newPath = $currentPath + ";C:\flutter\bin"
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Write-Host "PATH configurado!" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error al configurar PATH: $_" -ForegroundColor Red
    }
    
    Write-Host "Limpiando archivos temporales..." -ForegroundColor Green
    Remove-Item $flutterZip -Force -ErrorAction SilentlyContinue
    
    return $true
}

# Función para generar el APK
function Build-APK {
    Write-Host "[2/5] Verificando dependencias..." -ForegroundColor Yellow
    try {
        flutter doctor
    }
    catch {
        Write-Host "Error al ejecutar flutter doctor: $_" -ForegroundColor Red
        return $false
    }
    
    Write-Host ""
    Write-Host "[3/5] Instalando dependencias del proyecto..." -ForegroundColor Yellow
    try {
        flutter pub get
    }
    catch {
        Write-Host "Error al instalar dependencias: $_" -ForegroundColor Red
        return $false
    }
    
    Write-Host ""
    Write-Host "[4/5] Limpiando build anterior..." -ForegroundColor Yellow
    try {
        flutter clean
    }
    catch {
        Write-Host "Error al limpiar build: $_" -ForegroundColor Red
        return $false
    }
    
    Write-Host ""
    Write-Host "[5/5] Generando APK de release..." -ForegroundColor Yellow
    try {
        flutter build apk --release
        Write-Host "¡APK generado exitosamente!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error al generar APK: $_" -ForegroundColor Red
        return $false
    }
}

# Ejecutar el proceso completo
Write-Host "Verificando instalación de Flutter..." -ForegroundColor Yellow
if (Test-FlutterInstalled) {
    Write-Host "Flutter ya está instalado." -ForegroundColor Green
}
else {
    Write-Host "Flutter no encontrado. Instalando..." -ForegroundColor Yellow
    if (-not (Install-Flutter)) {
        Write-Host "Error en la instalación de Flutter. Saliendo..." -ForegroundColor Red
        exit 1
    }
    
    # Refrescar variables de entorno
    $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
}

# Generar APK
if (Build-APK) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "¡APK GENERADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "El APK se encuentra en:" -ForegroundColor Yellow
    Write-Host "build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
    Write-Host ""
    
    # Abrir la carpeta del APK
    $apkPath = "build\app\outputs\flutter-apk\"
    if (Test-Path $apkPath) {
        Write-Host "Abriendo carpeta del APK..." -ForegroundColor Green
        Start-Process "explorer.exe" -ArgumentList $apkPath
    }
}
else {
    Write-Host "Error al generar el APK." -ForegroundColor Red
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
