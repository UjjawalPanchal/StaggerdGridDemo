import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practice/ui/home_screen.dart';
import 'package:practice/utils/firebase_messaging_service.dart';
import 'package:practice/utils/utility.dart';

FireBaseMessagingService msgService = FireBaseMessagingService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await msgService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MyHomePage(),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Utility.printLog(" --- background message received ---");
  Utility.printLog(message.notification!.title);
  Utility.printLog(message.notification!.body);
  msgService.addNotificationToStorage(message);
}
