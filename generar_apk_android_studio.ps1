# Mario Touch Adventure - Android Studio APK Generator
# PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   MARIO TOUCH ADVENTURE - ANDROID STUDIO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar si Android Studio está instalado
function Test-AndroidStudioInstalled {
    $studioPath = "C:\Program Files\Android\Android Studio1\bin\studio64.exe"
    if (Test-Path $studioPath) {
        return $true
    }
    return $false
}

# Función para abrir Android Studio
function Open-AndroidStudio {
    Write-Host "[1/5] Abriendo Android Studio..." -ForegroundColor Yellow
    
    $studioPath = "C:\Program Files\Android\Android Studio1\bin\studio64.exe"
    $projectPath = "D:\mario_touch_adventure"
    
    try {
        Start-Process -FilePath $studioPath -ArgumentList $projectPath -WindowStyle Normal
        Write-Host "✅ Android Studio abierto correctamente" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error al abrir Android Studio: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Función para mostrar instrucciones
function Show-Instructions {
    Write-Host ""
    Write-Host "[2/5] Instrucciones para generar el APK:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 PASOS A SEGUIR EN ANDROID STUDIO:" -ForegroundColor White
    Write-Host ""
    Write-Host "1️⃣  Espera a que el proyecto se sincronice completamente" -ForegroundColor Cyan
    Write-Host "2️⃣  Ve a Build > Build Bundle(s) / APK(s) > Build APK(s)" -ForegroundColor Cyan
    Write-Host "3️⃣  O usa el atajo de teclado: Ctrl + Shift + F9" -ForegroundColor Cyan
    Write-Host "4️⃣  Espera a que termine la compilación (puede tomar varios minutos)" -ForegroundColor Cyan
    Write-Host "5️⃣  El APK estará en: build\app\outputs\flutter-apk\" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎯 UBICACIÓN DEL APK:" -ForegroundColor Yellow
    Write-Host "   D:\mario_touch_adventure\build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor White
    Write-Host ""
}

# Función para abrir la carpeta de salida
function Open-OutputFolder {
    Write-Host "[3/5] Abriendo carpeta de salida..." -ForegroundColor Yellow
    
    $outputPath = "D:\mario_touch_adventure\build\app\outputs\flutter-apk"
    
    # Crear la carpeta si no existe
    if (!(Test-Path $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
    }
    
    try {
        Start-Process "explorer.exe" -ArgumentList $outputPath
        Write-Host "✅ Carpeta de salida abierta" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error al abrir la carpeta: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Función para mostrar características del juego
function Show-GameFeatures {
    Write-Host ""
    Write-Host "[4/5] Características del juego mejorado:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎮 CARACTERÍSTICAS IMPLEMENTADAS:" -ForegroundColor White
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
}

# Función para mostrar instrucciones de instalación
function Show-InstallationInstructions {
    Write-Host ""
    Write-Host "[5/5] Instrucciones de instalación:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📱 PARA INSTALAR EN ANDROID:" -ForegroundColor White
    Write-Host "1️⃣  Habilitar fuentes desconocidas en Configuración > Seguridad" -ForegroundColor Cyan
    Write-Host "2️⃣  Copiar el APK a tu dispositivo Android" -ForegroundColor Cyan
    Write-Host "3️⃣  Tocar en el archivo APK para instalar" -ForegroundColor Cyan
    Write-Host "4️⃣  ¡Disfrutar del juego mejorado!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎯 CONTROLES DEL JUEGO:" -ForegroundColor White
    Write-Host "   ⬅️➡️ Movimiento | ⬆️ Salto | ⚔️ Ataque | ⏸️ Pausa" -ForegroundColor Cyan
    Write-Host ""
}

# Función principal
function Start-APKGeneration {
    Write-Host "🔍 Verificando Android Studio..." -ForegroundColor Yellow
    
    if (!(Test-AndroidStudioInstalled)) {
        Write-Host "❌ Android Studio no está instalado en la ubicación esperada" -ForegroundColor Red
        Write-Host "   Instala Android Studio desde: https://developer.android.com/studio" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "✅ Android Studio detectado" -ForegroundColor Green
    
    # Abrir Android Studio
    if (!(Open-AndroidStudio)) {
        return $false
    }
    
    # Mostrar instrucciones
    Show-Instructions
    
    # Abrir carpeta de salida
    Open-OutputFolder
    
    # Mostrar características
    Show-GameFeatures
    
    # Mostrar instrucciones de instalación
    Show-InstallationInstructions
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "¡PROCESO INICIADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎮 Sigue las instrucciones en Android Studio para generar el APK" -ForegroundColor White
    Write-Host "📱 El APK estará listo para instalar en tu dispositivo Android" -ForegroundColor White
    Write-Host ""
    
    return $true
}

# Ejecutar el proceso principal
Start-APKGeneration

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
