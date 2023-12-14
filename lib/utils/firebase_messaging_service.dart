/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:localstore/localstore.dart';
import 'package:practice/model/notification_pojo.dart';
import 'package:practice/utils/utility.dart';

class FireBaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final db = Localstore.instance;

  String? _token;

  String? get token => _token;

  Future init() async {
    if (Platform.isIOS) {
      final settings = await _requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _getToken();
        _registerForegroundMessageHandler();
      }
    } else {
      await _getToken();
      _registerForegroundMessageHandler();
    }
  }

  Future _getToken() async {
    _token = await _firebaseMessaging.getToken();
    Utility.printLog("FCM: $_token");
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _token = token;
    });
  }

  Future<NotificationSettings> _requestPermission() async {
    return await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      announcement: false,
    );
  }

  void _registerForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      Utility.printLog(" --- foreground message received ---");
      Utility.printLog(remoteMessage.notification!.title);
      Utility.printLog(remoteMessage.notification!.body);
      addNotificationToStorage(remoteMessage);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      Utility.printLog(" --- foreground message received ---");
      Utility.printLog(remoteMessage.notification!.title);
      Utility.printLog(remoteMessage.notification!.body);
    });
  }

  void addNotificationToStorage(message) {
    NotificationItemPojo notification = NotificationItemPojo(
      id: '${message.notification!.title.hashCode}',
      title: message.notification!.title,
      body: message.notification!.body,
    );
    notification.save();
  }
}
