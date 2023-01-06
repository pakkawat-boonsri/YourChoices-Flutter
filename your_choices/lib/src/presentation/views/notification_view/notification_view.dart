import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  final String uid;
  const NotificationView({super.key, required this.uid});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("NotificationView"),
      ),
    );
  }
}
