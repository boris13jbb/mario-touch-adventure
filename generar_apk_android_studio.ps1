# Mario Touch Adventure - Generador de APK con Android Studio/Flutter
# Script PowerShell Avanzado

param(
    [switch]$Verbose,
    [switch]$SkipDependencies,
    [switch]$Clean
)

# Configurar colores para la salida
$Host.UI.RawUI.ForegroundColor = "White"
$Host.UI.RawUI.BackgroundColor = "Black"

function Write-Header {
    param([string]$Message)
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "🎮 $Message" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️ $Message" -ForegroundColor Blue
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️ $Message" -ForegroundColor Yellow
}

# Función para verificar si un comando existe
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Función para ejecutar comando con manejo de errores
function Invoke-SafeCommand {
    param(
        [string]$Command,
        [string]$Description,
        [scriptblock]$OnError
    )
    
    Write-Info "Ejecutando: $Description"
    if ($Verbose) {
        Write-Host "Comando: $Command" -ForegroundColor Gray
    }
    
    try {
        Invoke-Expression $Command
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$Description completado"
            return $true
        } else {
            Write-Error "$Description falló (código: $LASTEXITCODE)"
            if ($OnError) {
                & $OnError
            }
            return $false
        }
    }
    catch {
        Write-Error "$Description falló: $($_.Exception.Message)"
        if ($OnError) {
            & $OnError
        }
        return $false
    }
}

# Inicio del script
Write-Header "Mario Touch Adventure - Generador de APK"
Write-Info "Iniciando proceso de generación del APK..."

# Verificar si estamos en el directorio correcto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Error "No se encontró pubspec.yaml. Asegúrate de estar en el directorio del proyecto Flutter."
    exit 1
}

# Verificar Flutter
Write-Info "Verificando instalación de Flutter..."
if (-not (Test-Command "flutter")) {
    Write-Warning "Flutter no está instalado o no está en el PATH"
    Write-Info "Instalando Flutter..."
    
    if (Test-Command "choco") {
        Invoke-SafeCommand "choco install flutter -y" "Instalación de Flutter" {
            Write-Error "No se pudo instalar Flutter. Instálalo manualmente desde https://flutter.dev"
            exit 1
        }
        
        Write-Info "Refrescando variables de entorno..."
        refreshenv
    } else {
        Write-Error "Chocolatey no está instalado. Instala Flutter manualmente desde https://flutter.dev"
        exit 1
    }
}

# Verificar versión de Flutter
Write-Info "Verificando versión de Flutter..."
$flutterVersion = flutter --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "Flutter detectado correctamente"
    if ($Verbose) {
        Write-Host $flutterVersion -ForegroundColor Gray
    }
} else {
    Write-Error "Error al verificar Flutter"
    exit 1
}

# Limpiar si se solicita
if ($Clean) {
    Write-Info "Limpiando proyecto..."
    Invoke-SafeCommand "flutter clean" "Limpieza del proyecto"
}

# Instalar dependencias
if (-not $SkipDependencies) {
    Write-Info "Instalando dependencias..."
    Invoke-SafeCommand "flutter pub get" "Instalación de dependencias" {
        Write-Error "Error al instalar dependencias. Verifica tu conexión a internet."
        exit 1
    }
} else {
    Write-Warning "Saltando instalación de dependencias"
}

# Generar APK
Write-Info "Generando APK de release..."
$startTime = Get-Date
Invoke-SafeCommand "flutter build apk --release" "Generación del APK" {
    Write-Error "Error al generar el APK. Verifica los errores arriba."
    exit 1
}

$endTime = Get-Date
$duration = $endTime - $startTime

# Verificar si el APK se generó correctamente
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Success "¡APK generado exitosamente!"
    Write-Host ""
    Write-Host "📱 Información del APK:" -ForegroundColor Cyan
    Write-Host "   📍 Ubicación: $apkPath" -ForegroundColor White
    Write-Host "   📏 Tamaño: $([math]::Round($apkSize, 2)) MB" -ForegroundColor White
    Write-Host "   ⏱️ Tiempo de compilación: $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🎮 Características del juego mejorado:" -ForegroundColor Cyan
    Write-Host "   ✅ Motor de Física Realista" -ForegroundColor Green
    Write-Host "   ✅ Sistema de Audio Profesional" -ForegroundColor Green
    Write-Host "   ✅ UI/UX Mejorado con Animaciones" -ForegroundColor Green
    Write-Host "   ✅ Sistema de Guardado Avanzado" -ForegroundColor Green
    Write-Host "   ✅ Controles Táctiles con Haptic Feedback" -ForegroundColor Green
    Write-Host "   ✅ Efectos Visuales y Partículas" -ForegroundColor Green
    Write-Host "   ✅ Sistema de Logros y Estadísticas" -ForegroundColor Green
    Write-Host "   ✅ Configuraciones Personalizables" -ForegroundColor Green
    Write-Host "   ✅ Optimización de Rendimiento" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "📱 Instrucciones de instalación:" -ForegroundColor Cyan
    Write-Host "   1. Habilitar fuentes desconocidas en Configuración > Seguridad" -ForegroundColor White
    Write-Host "   2. Copiar el APK a tu dispositivo Android" -ForegroundColor White
    Write-Host "   3. Tocar en el archivo APK para instalar" -ForegroundColor White
    Write-Host "   4. ¡Disfrutar del juego mejorado!" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🚀 ¡Tu Mario Touch Adventure ahora es completamente profesional!" -ForegroundColor Yellow
    Write-Host ""
    
    # Abrir la carpeta del APK
    $openFolder = Read-Host "¿Deseas abrir la carpeta del APK? (s/n)"
    if ($openFolder -eq "s" -or $openFolder -eq "S") {
        Invoke-Item "build\app\outputs\flutter-apk\"
    }
} else {
    Write-Error "El APK no se generó correctamente"
    exit 1
}

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
