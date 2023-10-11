class AppConfig {
  static const baseUrl = 'http://$ipAddress:3000';
  static const ipAddress = '192.168.43.37';
  // static const ipAddress = '10.0.2.2';
  // static const ipAddress = 'localhost';
}

enum BottomNavigationItem { home, favorites, add, messages, profile }
