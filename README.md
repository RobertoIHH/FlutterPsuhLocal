# pushnotifi

Una aplicación Flutter completa para la gestión de notificaciones locales con soporte para notificaciones instantáneas y programadas.

## 👥 Integrantes

- **Gonzalez Llamosas Noe Ramses**
- **Hernández Hernández Roberto Isaac**

## 📱 Descripción

PushNotifi es una aplicación desarrollada en Flutter que demuestra la implementación completa de notificaciones locales. La app permite enviar notificaciones instantáneas y programar notificaciones para tiempos específicos, con manejo inteligente de permisos y compatibilidad multiplataforma.

## ✨ Características

- **Notificaciones Instantáneas**: Envío inmediato de notificaciones
- **Notificaciones Programadas**: Programación de notificaciones para 5 segundos o 1 minuto
- **Gestión de Permisos**: Manejo automático de permisos de notificaciones y alarmas exactas
- **Interfaz Intuitiva**: UI limpia y fácil de usar
- **Multiplataforma**: Compatible con Android, iOS, Windows, macOS y Linux
- **Gestión Completa**: Ver notificaciones pendientes y cancelar todas las notificaciones

## 🔧 Tecnologías Utilizadas

- **Flutter 3.32.3**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **flutter_local_notifications**: Plugin para notificaciones locales
- **timezone**: Manejo de zonas horarias para notificaciones programadas

## 📋 Requisitos

- Flutter SDK >=3.32.0
- Dart SDK >=3.3.0
- Android Studio / VS Code
- Dispositivo Android API 21+ o iOS 12.0+

## 🚀 Instalación

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd pushnotifi
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## ⚙️ Configuración de Permisos

### Android
La aplicación solicita automáticamente los siguientes permisos:
- `POST_NOTIFICATIONS` - Para enviar notificaciones
- `SCHEDULE_EXACT_ALARM` - Para alarmas exactas (Android 12+)
- `USE_EXACT_ALARM` - Para usar alarmas exactas
- `RECEIVE_BOOT_COMPLETED` - Para mantener notificaciones después del reinicio
- `VIBRATE` - Para vibración en notificaciones
- `WAKE_LOCK` - Para despertar el dispositivo

### iOS
- Permisos de notificaciones solicitados automáticamente al iniciar la app

## 📱 Funcionalidades

### Pantalla Principal
- **Mostrar Notificación Ahora**: Envía una notificación instantánea
- **Programar en 5 segundos**: Programa una notificación para 5 segundos después
- **Programar en 1 minuto**: Programa una notificación para 1 minuto después
- **Ver Pendientes**: Muestra el número de notificaciones programadas
- **Cancelar Todas**: Cancela todas las notificaciones programadas

### Características Técnicas
- Manejo inteligente de errores de permisos
- Notificaciones informativas cuando faltan permisos de alarmas exactas
- Soporte para diferentes canales de notificación
- Configuración automática de timezone

## 🔐 Manejo de Permisos Especiales

### Alarmas y Recordatorios (Android 12+)
Si las notificaciones programadas no funcionan, es necesario activar manualmente el permiso:

1. Ve a **Configuración** → **Apps** → **pushnotifi**
2. Busca **"Alarmas y recordatorios"**
3. Activa el toggle

La aplicación detectará automáticamente cuando este permiso no esté disponible y mostrará una notificación informativa.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada y UI principal
├── notification_service.dart # Servicio de notificaciones
android/
├── app/src/main/
│   ├── AndroidManifest.xml   # Configuración de permisos Android
│   └── kotlin/.../MainActivity.kt
ios/
├── Runner/
│   └── Info.plist            # Configuración iOS
```

## 🛠️ Dependencias Principales

```yaml
dependencies:
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.4
```

## 🚨 Problemas Conocidos y Soluciones

### Android
- **Error "exact_alarms_not_permitted"**: Activar manualmente "Alarmas y recordatorios" en configuración
- **Notificaciones no aparecen**: Verificar que las notificaciones estén habilitadas para la app

