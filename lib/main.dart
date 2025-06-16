import 'package:flutter/material.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicio de notificaciones
  await NotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _notificationId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones Locales'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Gestión de Notificaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Botón para notificación inmediata
            ElevatedButton.icon(
              onPressed: _showInstantNotification,
              icon: Icon(Icons.notifications_active),
              label: Text('Mostrar Notificación Ahora'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 15),

            // Botón para notificación programada (5 segundos)
            ElevatedButton.icon(
              onPressed: _scheduleNotification5Seconds,
              icon: Icon(Icons.schedule),
              label: Text('Programar en 5 segundos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 15),

            // Botón para notificación programada (1 minuto)
            ElevatedButton.icon(
              onPressed: _scheduleNotification1Minute,
              icon: Icon(Icons.timer),
              label: Text('Programar en 1 minuto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 30),

            // Botones de gestión
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showPendingNotifications,
                  icon: Icon(Icons.list),
                  label: Text('Ver Pendientes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _cancelAllNotifications,
                  icon: Icon(Icons.clear_all),
                  label: Text('Cancelar Todas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInstantNotification() async {
    await NotificationService.showInstantNotification(
      id: _notificationId++,
      title: '¡Notificación Instantánea!',
      body: 'Esta es una notificación que se muestra inmediatamente',
      payload: 'instant_notification',
    );

    _showSnackBar('Notificación mostrada');
  }

  void _scheduleNotification5Seconds() async {
    final scheduledDate = DateTime.now().add(Duration(seconds: 5));

    await NotificationService.scheduleNotification(
      id: _notificationId++,
      title: 'Notificación Programada',
      body: 'Esta notificación fue programada para 5 segundos',
      scheduledDate: scheduledDate,
      payload: 'scheduled_5s',
    );

    _showSnackBar('Notificación programada para 5 segundos');
  }

  void _scheduleNotification1Minute() async {
    final scheduledDate = DateTime.now().add(Duration(minutes: 1));

    await NotificationService.scheduleNotification(
      id: _notificationId++,
      title: 'Recordatorio',
      body: 'Han pasado 60 segundos desde que programaste esta notificación',
      scheduledDate: scheduledDate,
      payload: 'scheduled_1m',
    );

    _showSnackBar('Notificación programada para 1 minuto');
  }

  void _showPendingNotifications() async {
    final pending = await NotificationService.getPendingNotifications();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notificaciones Pendientes'),
        content: Text(
          pending.isEmpty
              ? 'No hay notificaciones pendientes'
              : 'Tienes ${pending.length} notificación(es) programada(s)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _cancelAllNotifications() async {
    await NotificationService.cancelAllNotifications();
    _showSnackBar('Todas las notificaciones canceladas');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}