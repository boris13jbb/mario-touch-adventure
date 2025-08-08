# 🎮 Mario Touch Adventure - Generar APK con Android Studio

## 📱 Método Recomendado: Android Studio + Flutter

### 🚀 Opción 1: Script Automático (MÁS FÁCIL)

#### Usando el Script Batch:
```bash
# Ejecutar el script batch
generar_apk_android_studio.bat
```

#### Usando el Script PowerShell:
```powershell
# Ejecutar el script PowerShell
.\generar_apk_android_studio.ps1

# Con opciones adicionales:
.\generar_apk_android_studio.ps1 -Verbose -Clean
```

### 🛠️ Opción 2: Comandos Manuales

#### Paso 1: Verificar Flutter
```bash
flutter --version
```

#### Paso 2: Instalar Dependencias
```bash
flutter pub get
```

#### Paso 3: Generar APK
```bash
flutter build apk --release
```

#### Paso 4: Ubicación del APK
El APK se generará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 🎯 Opción 3: Android Studio GUI

#### Paso 1: Abrir Android Studio
1. Abre Android Studio
2. Selecciona "Open an existing project"
3. Navega a tu proyecto `mario_touch_adventure`
4. Selecciona la carpeta del proyecto

#### Paso 2: Configurar el Proyecto
1. Espera a que Android Studio indexe el proyecto
2. Ve a `File > Sync Project with Gradle Files`
3. Espera a que se complete la sincronización

#### Paso 3: Generar APK
1. Ve a `Build > Flutter > Build APK`
2. O usa `Build > Generate Signed Bundle / APK`
3. Selecciona "APK" y "release"
4. Haz clic en "Finish"

### 📱 Instalación en Android

#### Paso 1: Habilitar Fuentes Desconocidas
1. Ve a **Configuración** en tu dispositivo Android
2. Ve a **Seguridad** o **Privacidad**
3. Activa **Fuentes desconocidas** o **Instalar apps desconocidas**

#### Paso 2: Instalar APK
1. Copia el archivo `app-release.apk` a tu dispositivo Android
2. Toca en el archivo APK
3. Sigue las instrucciones de instalación
4. ¡Disfruta del juego!

### 🎮 Características del Juego Mejorado

#### ✅ Motor de Física Realista
- Gravedad y saltos realistas
- Colisiones precisas
- Movimiento fluido y natural

#### ✅ Sistema de Audio Profesional
- Música de fondo dinámica
- Efectos de sonido para todas las acciones
- Controles de volumen independientes

#### ✅ UI/UX Mejorado
- Animaciones suaves y fluidas
- Diseño responsivo
- Efectos visuales profesionales

#### ✅ Sistema Avanzado
- Guardado automático del progreso
- Sistema de logros desbloqueables
- Estadísticas detalladas del juego

#### ✅ Controles Táctiles
- Botones de movimiento (izquierda/derecha)
- Botón de salto
- Botón de ataque
- Botón de pausa

### 🏆 Logros Disponibles

- **Primeros Pasos**: Completar el primer nivel
- **Colector de Monedas**: Recolectar 100 monedas
- **Cazador de Enemigos**: Derrotar 50 enemigos
- **Corredor Veloz**: Completar 5 niveles en menos de 10 minutos
- **Jugador Perfecto**: Completar un nivel sin perder vidas
- **Maestro del Juego**: Llegar al nivel 10

### 🔧 Solución de Problemas

#### Error: "Flutter no está instalado"
```bash
# Instalar Flutter con Chocolatey
choco install flutter -y
refreshenv
```

#### Error: "Dependencias no encontradas"
```bash
# Limpiar y reinstalar
flutter clean
flutter pub get
```

#### Error: "Gradle build failed"
```bash
# Limpiar cache de Gradle
cd android
./gradlew clean
cd ..
flutter build apk --release
```

#### Error: "APK no se genera"
1. Verifica que tienes Java JDK instalado
2. Verifica que tienes Android SDK instalado
3. Ejecuta `flutter doctor` para diagnosticar problemas

### 📊 Información del APK

- **Tamaño**: ~15-25 MB
- **Versión mínima de Android**: API 21 (Android 5.0)
- **Arquitecturas soportadas**: ARM64, ARM, x86_64
- **Permisos requeridos**: Internet, Vibración

### 🚀 Comandos Útiles

```bash
# Verificar estado de Flutter
flutter doctor

# Limpiar proyecto
flutter clean

# Instalar dependencias
flutter pub get

# Generar APK de debug (más rápido para pruebas)
flutter build apk --debug

# Generar APK de release (para distribución)
flutter build apk --release

# Generar APK dividido por arquitectura (más pequeño)
flutter build apk --split-per-abi --release
```

### 📞 Soporte

Si encuentras problemas:

1. **Verifica Flutter**: `flutter doctor`
2. **Revisa logs**: Los errores aparecen en la consola
3. **Consulta documentación**: https://flutter.dev/docs
4. **Comunidad**: Foros de Flutter y Stack Overflow

### 🎯 ¡Tu APK Está Listo!

Una vez que el proceso termine, encontrarás tu APK en:
```
D:\mario_touch_adventure\build\app\outputs\flutter-apk\app-release.apk
```

¡Copia este archivo a tu dispositivo Android e instálalo para disfrutar del Mario Touch Adventure mejorado! 🎮✨

---

**¡Tu Mario Touch Adventure ahora es completamente profesional y realista!** 🚀
