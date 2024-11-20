import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linyu_mobile/api/user_api.dart';

final _userApi = UserApi();

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 初始化通知服务
  static Future<void> initialize() async {
    // Android设置
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS设置
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 初始化设置
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsIOS,
    );

    // 初始化插件
    await _notificationsPlugin.initialize(
      initializationSettings,
      // 处理通知点击事件
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 处理通知点击
        print('通知点击: ${response.payload}');
      },
    );

    // 对于 Android 13 及以上版本，请求通知权限
    if (Platform.isAndroid) {
      final platformVersion = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getNotificationChannels();
      if (platformVersion != null) {
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    }
  }

  // 创建通知渠道（Android）
  static Future<void> createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // 显示普通通知
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // 显示带进度的通知
  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'progress_channel',
      'Progress Notifications',
      channelDescription: 'Notifications with progress bar',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
    );
  }

  // 显示带图片的通知
  static Future<void> showBigPictureNotification({
    required int id,
    required String title,
    required String body,
    required String imagePath,
  }) async {
    final bigPicture = await _getStyleInformation(imagePath);

    final androidDetails = AndroidNotificationDetails(
      'big_picture_channel',
      'Big Picture Notifications',
      channelDescription: 'Notifications with big picture',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPicture,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
    );
  }

  // 获取大图样式信息
  static Future<BigPictureStyleInformation> _getStyleInformation(
      String imagePath) async {
    await _userApi.getNetworkImage(imagePath);

    return BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(
          await _userApi.getNetworkImage(imagePath)),
      contentTitle: '',
      htmlFormatContentTitle: true,
      summaryText: '',
      htmlFormatSummaryText: true,
    );
  }

  // 取消指定ID的通知
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // 取消所有通知
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
