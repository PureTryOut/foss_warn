import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foss_warn/enums/severity.dart';
import 'package:foss_warn/extensions/context.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

///
/// ID 2: Status notification
/// ID 3: No Places selected warning
/// ID 4: legacy warning
/// ID 5: subscription error
class NotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationsDetails(
    String channel,
  ) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'de.nucleus.foss_warn.notifications_${channel.trim().toLowerCase()}',
        // TODO(Nucleus): find solution to translate this
        "Warnstufe: ${Severity.translateWarningSeverity(channel)}", // ignore: deprecated_member_use_from_same_package
        groupKey: "FossWarnWarnings",
        category: AndroidNotificationCategory.message,
        priority: Priority.max,

        // enable multiline notification
        styleInformation: const BigTextStyleInformation(''),
        color: Colors.red, // makes the icon red,
        ledColor: Colors.red,
        ledOffMs: 100,
        ledOnMs: 100,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static Future _statusNotificationsDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'de.nucleus.foss_warn.notifications_state',
        'Statusanzeige',
        channelDescription: 'Status der Hintergrund Updates',
        groupKey: "FossWarnService",
        category: AndroidNotificationCategory.service,
        importance: Importance.low,
        priority: Priority.min,
        playSound: false,
        channelShowBadge: false,
        ongoing: true, // to prevent canceling

        //@TODO: show an other icon for status notification
        //enable multiline notification
        styleInformation: BigTextStyleInformation(''),
        color: Colors.green, // makes the icon green,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // show a notification // with named parameters
  static Future showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required String channel,
  }) async {
    _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationsDetails(channel),
      payload: payload,
    );
    showGroupNotification();
  }

  static Future showStatusNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _statusNotificationsDetails(),
      payload: payload,
    );
  }

  static void showGroupNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'foss_warn', 'Benachrichtigungen',
        channelDescription: 'FOSS Warn Benachrichtigungen',
        groupKey: "FossWarnWarnings",
        setAsGroupSummary: true,
        importance: Importance.max,
        priority: Priority.max,
        playSound: false,

        //enable multiline notification
        styleInformation: BigTextStyleInformation(''),
        color: Colors.red, // makes the icon red,
        ledColor: Colors.red,
        ledOffMs: 100,
        ledOnMs: 100,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      "Warnungen",
      "Es gibt für mehrere Orte Warnungen",
      notificationDetails,
    );
  }

  static Future<void> _setupAndroidNotificationChannels(
    BuildContext context,
  ) async {
    var localizations = context.localizations;

    final androidNotificationPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidNotificationPlugin == null) {
      return;
    }

    // Request notifications permission (Android 13+)
    await androidNotificationPlugin.requestNotificationsPermission();

    // Request schedule exact alarm permission (Android 14+)
    await androidNotificationPlugin.requestExactAlarmsPermission();

    // init the different notifications channels
    await androidNotificationPlugin.createNotificationChannelGroup(
      AndroidNotificationChannelGroup(
        "de.nucleus.foss_warn.notifications_emergency_information",
        localizations.notification_channel_group_emergency_information_title,
        description: localizations
            .notification_channel_group_emergency_information_description,
      ),
    );

    await androidNotificationPlugin.createNotificationChannelGroup(
      AndroidNotificationChannelGroup(
        "de.nucleus.foss_warn.notifications_other",
        localizations.notification_channel_miscellaneous_title,
        description:
            localizations.notification_channel_miscellaneous_description,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_minor",
        localizations.notification_channel_warning_level_low_title,
        description:
            localizations.notification_channel_warning_level_low_description,
        groupId: "de.nucleus.foss_warn.notifications_emergency_information",
        importance: Importance.max,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_moderate",
        localizations.notification_channel_warning_level_moderate_title,
        description: localizations
            .notification_channel_warning_level_moderate_description,
        groupId: "de.nucleus.foss_warn.notifications_emergency_information",
        importance: Importance.max,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_severe",
        localizations.notification_channel_warning_level_severe_title,
        description:
            localizations.notification_channel_warning_level_severe_description,
        groupId: "de.nucleus.foss_warn.notifications_emergency_information",
        importance: Importance.max,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_extreme",
        localizations.notification_channel_warning_level_extreme_title,
        description: localizations
            .notification_channel_warning_level_extreme_description,
        groupId: "de.nucleus.foss_warn.notifications_emergency_information",
        importance: Importance.max,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_update",
        localizations.notification_channel_update_title,
        description: localizations.notification_channel_update_description,
        groupId: "de.nucleus.foss_warn.notifications_emergency_information",
        importance: Importance.low,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_state",
        localizations.notification_channel_status_indicator_title,
        description:
            localizations.notification_channel_status_indicator_description,
        groupId: "de.nucleus.foss_warn.notifications_other",
        importance: Importance.low,
      ),
    );

    await androidNotificationPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        "de.nucleus.foss_warn.notifications_other",
        localizations.notification_channel_other_title,
        description: localizations.notification_channel_other_description,
        groupId: "de.nucleus.foss_warn.notifications_other",
        importance: Importance.defaultImportance,
      ),
    );
  }

  static Future<void> init(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    if (Platform.isAndroid) {
      await _setupAndroidNotificationChannels(context);
      await _cleanUpOldNotificationChannels();
    }

    // when App is closed
    final details = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null &&
        details.notificationResponse != null &&
        details.didNotificationLaunchApp) {
      onNotification.add(details.notificationResponse!.payload);
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  /// Request notification permission on Android. This methode is currently
  /// used in the welcome view. This should later be migrated into a cross
  /// platform solution
  static Future<bool?> requestNotificationPermission() async {
    final androidNotificationPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidNotificationPlugin != null) {
      // Request notifications permission (Android 13+)
      return await androidNotificationPlugin.requestNotificationsPermission();
    } else {
      return null;
    }
  }

  /// Request exact alarm permission on Android. This methode is currently
  /// used in the welcome view. This should later be migrated into a cross
  /// platform solution. This permission is currently not used for notifications
  /// but will be necessary if the alarmManager plugin in combination with
  /// the UnifiedPush plugin is working again. We should move the permission
  /// handling later out of the notifications setup.
  Future<bool?> requestExactAlarmPermission() async {
    final androidNotificationPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidNotificationPlugin != null) {
      // Request schedule exact alarm permission (Android 14+)
      return await androidNotificationPlugin.requestExactAlarmsPermission();
    } else {
      return null;
    }
  }

  static Future<void> _cleanUpOldNotificationChannels() async {
    List<String> channelIds = [
      "de.nucleus.foss_warn.notifications_minor",
      "de.nucleus.foss_warn.notifications_moderate",
      "de.nucleus.foss_warn.notifications_severe",
      "de.nucleus.foss_warn.notifications_extreme",
      "de.nucleus.foss_warn.notifications_state",
      "de.nucleus.foss_warn.notifications_other",
      "de.nucleus.foss_warn.notifications_update",
    ];

    Future<void> removeNotificationChannel(
      AndroidNotificationChannel channel,
    ) async =>
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.deleteNotificationChannel(channel.id);

    var allNotificationChannels = (await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getNotificationChannels());
    if (allNotificationChannels == null) return;

    await Future.wait([
      for (var channel in allNotificationChannels) ...[
        if (!channelIds.contains(channel.id)) ...[
          removeNotificationChannel(channel),
        ],
      ],
    ]);
  }

  static Future<void> onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) async =>
      onNotification.add(notificationResponse?.payload);

  /// cancel one notification with the given id
  static cancelOneNotification(id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);

    // cancel summery notification if it is the last one
    List<ActiveNotification>? activeNotifications =
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications();

    if (activeNotifications!.length == 2 &&
        activeNotifications.any(
          (element) =>
              element.channelId == "de.nucleus.foss_warn.notifications_state",
        )) {
      if (activeNotifications[0].id == 0) {
        // summery notification has id 0
        cancelOneNotification(0);
      }
    }
  }

  /// cancel all notifications
  static cancelAllNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
