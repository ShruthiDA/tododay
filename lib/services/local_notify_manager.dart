import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotifyManager {
  late FlutterLocalNotificationsPlugin flnPlugin;
  var initSetting;

  BehaviorSubject<ReceieveNotification> get didRecieve =>
      BehaviorSubject<ReceieveNotification>();

  LocalNotifyManager.init() {
    flnPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIosPermission();
    }
    initilizePlatform();
  }

  requestIosPermission() {
    flnPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  initilizePlatform() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notificationicon');

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: (id, title, body, payload) async {
              ReceieveNotification notif =
                  ReceieveNotification(id, title, body, payload);
              didRecieve.add(notif);
            });

    initSetting = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  setOnNotificationRecieve(Function onNotificationRecieve) {
    didRecieve.listen((notification) {
      onNotificationRecieve(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flnPlugin.initialize(initSetting,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 1', 'CHANNEL_NAME 1',
        importance: Importance.high, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.show(0, "title", "body", platformChannel,
        payload: 'Shruthi payload');
  }

  Future<void> showScheduledNotification() async {
    var scgeduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 20));
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 2', 'CHANNEL_NAME 2',
        importance: Importance.high, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.schedule(
        0, "title", "body", scgeduleNotificationDateTime, platformChannel,
        payload: 'Shruthi new payload');
  }

  Future<void> showDailyAtTimeNotification() async {
    var time = Time(15, 50, 0);
    var scgeduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 20));
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_NAME 3',
        importance: Importance.high, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.showDailyAtTime(0, "title", "body", time, platformChannel,
        payload: 'Shruthi new payload');
  }

  Future<void> showWeeklyAtDayTimeNotification() async {
    var time = Time(15, 50, 0);
    var scgeduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 20));
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 4', 'CHANNEL_NAME 4',
        importance: Importance.high, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.showWeeklyAtDayAndTime(
        0, "title", "body", Day.monday, time, platformChannel,
        payload: 'Shruthi new payload');
  }

  Future<void> cancelNotification(int id) async {
    await flnPlugin.cancel(id);
  }

  Future<void> cancelAllNotification(int id) async {
    await flnPlugin.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceieveNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceieveNotification(this.id, this.title, this.body, this.payload);
}
