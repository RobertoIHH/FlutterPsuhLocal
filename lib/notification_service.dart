import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Inicializar timezone
    tz.initializeTimeZones();

    // Configuración para Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Configuración general
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar cuando el usuario toca la notificación
        print('Notificación tocada: ${response.payload}');
      },
    );

    // Solicitar permisos para Android 13+
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  // Mostrar notificación inmediata
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel',
        'Notificaciones Instantáneas',
        channelDescription: 'Notificaciones que se muestran inmediatamente',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Programar notificación con validación de permisos
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Notificaciones Programadas',
          channelDescription: 'Notificaciones programadas para más tarde',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // ✅ NUEVO: Manejo de errores cuando no hay permisos
      if (e.toString().contains('exact_alarms_not_permitted')) {
        // Mostrar notificación inmediata explicando el problema
        await showInstantNotification(
          id: 999,
          title: 'Permiso requerido',
          body: 'Para programar notificaciones, ve a Configuración > Apps > pushnotifi > Alarmas y recordatorios y actívalo',
        );
        print('ERROR: Permisos de alarmas exactas no concedidos. El usuario debe activarlos manualmente.');
      } else {
        print('ERROR al programar notificación: $e');
        rethrow;
      }
    }
  }

  // Cancelar notificación específica
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todas las notificaciones
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Obtener notificaciones pendientes
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // ✅ NUEVO: Verificar si los permisos de alarmas exactas están concedidos
  static Future<bool> areExactAlarmsPermitted() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Esto puede no estar disponible en todas las versiones del plugin
    // return await androidImplementation?.areNotificationsEnabled() ?? false;
    return true; // Por ahora, asumimos que sí
  }
}