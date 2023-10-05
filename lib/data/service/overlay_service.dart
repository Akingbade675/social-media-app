import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallKitService {
  static Future<void> initializeService() async {
    // check is android version is 13 or above
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final version = (await deviceInfo.androidInfo).version.release;
      if (int.parse(version) >= 13) {
        FlutterCallkitIncoming.requestNotificationPermission({
          "rationaleMessagePermission":
              "Notification permission is required, to show notification.",
          "postNotificationMessageRequired":
              "Notification permission is required, Please allow notification permission from setting."
        });
      }
    }
  }

  static Future<void> startedOutgoingCall(String uuid) async {
    CallKitParams params = CallKitParams(
      id: uuid,
      handle: '1234567890',
      appName: 'Social Media App',
      nameCaller: 'Bhobo',
      avatar: 'https://i.pravatar.cc/150?img=3',
      type: 1,
      duration: 60,
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: {
        'roomId': uuid,
      },
    );

    await FlutterCallkitIncoming.startCall(params);
  }

  static Future<void> showIncomingCall({
    required String uuid,
    required String callerName,
    String? callerHandle,
    String? callerAvatar,
  }) async {
    CallKitParams params = CallKitParams(
      id: uuid,
      handle: callerHandle ?? '1234567890',
      appName: 'Social Media App',
      nameCaller: callerName,
      avatar: 'https://i.pravatar.cc/150?img=3',
      type: 1,
      duration: 60,
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: {
        'roomId': uuid,
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/temp/girl_5.jpg',
        actionColor: '#4CAF50',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> endCall(String uuid) async {
    await FlutterCallkitIncoming.endCall(uuid);
  }

  static Future<void> listenForEvents() async {
    FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event?.event) {
        case Event.actionCallIncoming:
          print('Action call incoming');
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          print('Action call start');
          break;
        case Event.actionCallAccept:
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          print('Action call accepted');
          break;
        default:
      }
    });
  }
}
