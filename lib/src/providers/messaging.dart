part of employ.provider;

class Messaging {
  final FlutterLocalNotificationsPlugin localNotificator =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize local notifications
    await localNotificator.getNotificationAppLaunchDetails();
    await localNotificator.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_notif'),
        iOS: DarwinInitializationSettings(
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        ),
      ),
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'employ_notifications', // ID
      'Employ Notifications', // Name
      description: 'Notificaciones de la app Employ',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    await localNotificator
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configure Firebase foreground notifications
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔥 NOTIFICATION RECEIVED! ${message.messageId}');
      debugPrint('📋 Title: ${message.notification?.title}');
      debugPrint('📋 Body: ${message.notification?.body}');
      debugPrint('📋 Data: ${message.data}');
      
      // Show local notification
      final platform = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          enableVibration: true,
          priority: Priority.high,
          ongoing: false,
          autoCancel: true,
          icon: '@mipmap/ic_notif',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      
      String title = message.notification?.title ?? message.data['title'] ?? 'Employ';
      String body = message.notification?.body ?? message.data['body'] ?? 'Nueva notificación';
      
      if (title.isNotEmpty && body.isNotEmpty) {
        localNotificator.show(
          message.hashCode,
          title,
          body,
          platform,
          payload: message.data.toString(),
        );
      }
    });

    // Handle notification taps when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.messageId}');
      // Handle navigation based on message data if needed
    });
  }

  void subscribe(Employee? employee) {
    if (employee == null) return;
    debugPrint('📢 SUBSCRIBING TO TOPIC: ${employee.id}');
    FirebaseMessaging.instance.subscribeToTopic(employee.id);
  }

  void unsubscribe(Employee? employee) {
    if (employee == null) return;
    FirebaseMessaging.instance.unsubscribeFromTopic(employee.id);
  }

  Future<void> grantedPermission(BuildContext context) async {
    final res = await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    if (res.authorizationStatus == AuthorizationStatus.denied) {
      await checkPermission(context, Permission.notification);
    }
  }

  Future<String?> getId() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
