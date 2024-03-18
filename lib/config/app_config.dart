import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class AppConfig {
  static const baseUrl = 'http://$ipAddress:3000';
  static const ipAddress = '192.168.43.37';
  // static const ipAddress = '10.0.2.2';
  // static const ipAddress = 'localhost';

  static getBaseUrl() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      if (info.isPhysicalDevice) {
        return 'http://192.168.43.37:3000';
      } else {
        return 'http://10.0.2.2:3000';
      }
    }
  }
}

enum BottomNavigationItem { home, favorites, add, messages, profile }
