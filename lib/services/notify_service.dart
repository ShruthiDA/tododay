// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import '../models/task.dart';
// import '../ui/notification_detail.dart';

// class NotifyService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   initializeNotification() async {
//     tz.initializeTimeZones();
//     _configureLocalTimezone();

//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('notificationicon');

//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//             requestSoundPermission: false,
//             requestBadgePermission: false,
//             requestAlertPermission: false,
//             onDidReceiveLocalNotification: onDidReceiveLocalNotification);

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   Future onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page

//     //Get.dialog(Text("Welcome to FLutter"));
//   }

//   Future selectNotification(String? payload) async {
//     if (payload != null) {
//       print('notification payload: $payload');
//     } else {
//       print("Notification Done");
//     }
//     //Get.dialog(Text("Welcome to FLutter"));
//   // Get.to(() => NotificationDetailPage(label: payload));
//   }

//   void requestIOSPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   //Sends a immediate notification
//   displayNotification({required String title, required String body}) async {

//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max, priority: Priority.high);

//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

//     var platformChannelSpecifics = new NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'It could be anything you pass',
//     );
//   }

//   //Sends a notification after 5 secs
//   scheduledNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'theme changes 5 seconds ago',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);
//   }

//   scheduledNotificationNew(
//       int hour, int minute, Task task, DateTime taskDate) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!.toInt(),
//         "Remainder ${task.title}",
//         "${task.note}",
//         _getScheduleDateTime(taskDate, hour, minute),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);
//     // payload: "${task.title}|${task.note}");
//   }

//   //Sends a notification after 5 secs
//   scheduledTaskNotification(Task task, DateTime startTime) async {
//     var message = "Your task ${task.title} starts in ${task.remind} minutes";
//     final tzdatetime = tz.TZDateTime.from(startTime, tz.local);
//     var duration = task.remind! * 60;

//     //
//     print("duration.........${duration}");
//     print("startTime.........${startTime}");
//     print("startTime.........${task.remind}");
//     print(
//         "After subtract.........${tzdatetime.subtract(Duration(seconds: duration))}");
//     print("After subtract.........${tzdatetime}");
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Reminder from Plan Today',
//         message,
//         tzdatetime,
//         //.subtract(Duration(seconds: duration)),
//         //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }

//   tz.TZDateTime _getScheduleDateTime(
//       DateTime scheduledDate, int hour, int minute) {
//     //final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     final tzdatetime = tz.TZDateTime.from(scheduledDate, tz.local);
//     tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, tzdatetime.year,
//         tzdatetime.month, tzdatetime.day, hour, minute);
//     print("scheduled at ${scheduleDate}");
//     return scheduleDate;
//   }

//   Future<void> _configureLocalTimezone() async {
//     tz.initializeTimeZones();
//     final String timeZOne = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZOne));
//   }
// }
