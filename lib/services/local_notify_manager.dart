import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import '../models/task.dart';

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

  Future<void> showScheduledNotification(
      int id, Task task, DateTime atTime) async {
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 1', 'CHANNEL_SCHEDULED_DATE',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.schedule(
        id, "Task Reminder", task.title, atTime, platformChannel,
        payload: "${task.title}|${task.note}");
  }

  Future<void> showDailyAtTimeNotification(
      int id, Task task, TimeOfDay atTime) async {
    var time = Time(atTime.hour, atTime.minute, 0);
    var scgeduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 20));
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 2', 'CHANNEL_DAILY',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.showDailyAtTime(
        id, "Task Reminder", task.title, time, platformChannel,
        payload: "${task.title}|${task.note}");
  }

  Future<void> showWeeklyAtDayTimeNotification(
      int id, Task task, TimeOfDay atTime) async {
    var time = Time(atTime.hour, atTime.minute, 0);
    var scgeduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 20));
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_WEEKLY',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    if (task.repeat == "Weekend") {
      await flnPlugin.showWeeklyAtDayAndTime(id * 11, "Task Reminder",
          task.title, Day.saturday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      await flnPlugin.showWeeklyAtDayAndTime(id * 12, "Task Reminder",
          task.title, Day.sunday, time, platformChannel,
          payload: "${task.title}|${task.note}");
    } else {
      await flnPlugin.showWeeklyAtDayAndTime(id * 13, "Task Reminder",
          task.title, Day.monday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      await flnPlugin.showWeeklyAtDayAndTime(id * 14, "Task Reminder",
          task.title, Day.tuesday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      await flnPlugin.showWeeklyAtDayAndTime(id * 15, "Task Reminder",
          task.title, Day.wednesday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      await flnPlugin.showWeeklyAtDayAndTime(id * 14, "Task Reminder",
          task.title, Day.thursday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      await flnPlugin.showWeeklyAtDayAndTime(id * 15, "Task Reminder",
          task.title, Day.friday, time, platformChannel,
          payload: "${task.title}|${task.note}");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flnPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
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
