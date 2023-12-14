/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practice/main.dart';
import 'package:practice/model/notification_pojo.dart';
import 'package:practice/utils/utility.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationItems = <String, NotificationItemPojo>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = msgService.db.collection(collectionName).stream.listen((event) {
      setState(() {
        final item = NotificationItemPojo.fromMap(event);
        notificationItems.putIfAbsent(item.id, () => item);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.keyboard_backspace_rounded),
        ),
        title: const Text("Notifications"),
      ),
      body: ListView.separated(
        itemCount: notificationItems.keys.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          final key = notificationItems.keys.elementAt(index);
          final item = notificationItems[key]!;
          return Card(
            color: Colors.white,
            elevation: 5,
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.body),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}
