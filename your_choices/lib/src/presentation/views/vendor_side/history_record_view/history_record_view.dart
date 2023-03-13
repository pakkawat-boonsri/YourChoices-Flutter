import 'package:flutter/material.dart';

class HistoryRecordView extends StatefulWidget {
  final String uid;
  const HistoryRecordView({Key? key, required this.uid}) : super(key: key);

  @override
  State<HistoryRecordView> createState() => _HistoryRecordViewState();
}

class _HistoryRecordViewState extends State<HistoryRecordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("HistoryRecordView"),
      ),
    );
  }
}
