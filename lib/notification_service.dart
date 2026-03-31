import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      debugPrint('Notification payload: $payload');
      // Handle notification tap
    }
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'pet_reminders',
            'Pet Reminders',
            channelDescription: 'Notifications for pet care reminders',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      // Only schedule if the date is in the future
      if (tzScheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzScheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );

        debugPrint(
          'Scheduled notification $id for ${tzScheduledDate.toString()}',
        );
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: id);
      debugPrint('Cancelled notification $id');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('Cancelled all notifications');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'pet_reminders',
            'Pet Reminders',
            channelDescription: 'Notifications for pet care reminders',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );

      debugPrint('Showed immediate notification: $title');
    } catch (e) {
      debugPrint('Error showing immediate notification: $e');
    }
  }

  // Schedule recurring reminders
  Future<void> scheduleRecurringReminder({
    required int id,
    required String title,
    required String body,
    required DateTime initialDate,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'pet_reminders',
            'Pet Reminders',
            channelDescription: 'Notifications for pet care reminders',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      final tz.TZDateTime tzInitialDate = tz.TZDateTime.from(
        initialDate,
        tz.local,
      );

      if (tzInitialDate.isAfter(tz.TZDateTime.now(tz.local))) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzInitialDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
          matchDateTimeComponents: _getDateTimeComponents(repeatInterval),
        );

        debugPrint('Scheduled recurring notification $id');
      }
    } catch (e) {
      debugPrint('Error scheduling recurring notification: $e');
    }
  }

  DateTimeComponents? _getDateTimeComponents(RepeatInterval repeatInterval) {
    switch (repeatInterval) {
      case RepeatInterval.daily:
        return DateTimeComponents.time;
      case RepeatInterval.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case RepeatInterval.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case RepeatInterval.yearly:
        return DateTimeComponents.dateAndTime;
      default:
        return null;
    }
  }
}

enum RepeatInterval { none, daily, weekly, monthly, yearly }
