import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/styles/app_colors.dart';

enum NotificationType {
  call,
  message,
}

class NotificationService {
  static Future<void> initializeNotification() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'call_channel',
          channelName: 'Call Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: AppColor.primary,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
        NotificationChannel(
          channelKey: 'message_channel',
          channelName: 'Messages Notification',
          channelDescription: 'Notification for new messages',
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          ledColor: Colors.white,
          defaultColor: AppColor.primary,
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'accept_call') {
      MyApp.navigatorKey.currentState?.pushNamed(AppRoutes.videoCall);
      await AwesomeNotifications().cancel(receivedAction.id ?? -1);
    } else if (receivedAction.buttonKeyPressed == 'reject_call') {
      await AwesomeNotifications().cancel(receivedAction.id ?? -1);
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    required final NotificationType notificationType,
    final ActionType actionType = ActionType.Default,
    final List<NotificationActionButton>? actionButtons,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 142527,
        channelKey: notificationType == NotificationType.call
            ? 'call_channel'
            : 'message_channel',
        title: title,
        body: body,
        bigPicture: 'asset://assets/temp/girl_2.jpg',
        actionType: actionType,
        summary: 'New message received',
        notificationLayout: notificationType == NotificationType.call
            ? NotificationLayout.Default
            : NotificationLayout.MessagingGroup,
        category: notificationType == NotificationType.call
            ? NotificationCategory.Call
            : NotificationCategory.Social,
        wakeUpScreen: true,
        fullScreenIntent: true,
        criticalAlert: true,
        autoDismissible: false,
      ),
      actionButtons: actionButtons,
    );
  }
}
