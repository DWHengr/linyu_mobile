import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<void> permissionRequest() async {
    await requestNotificationPermission();
  }

  static Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }
}
