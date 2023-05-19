import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';

class CustomerOrderHistoryView extends StatefulWidget {
  const CustomerOrderHistoryView({super.key});

  @override
  State<CustomerOrderHistoryView> createState() =>
      _CustomerOrderHistoryViewState();
}

class _CustomerOrderHistoryViewState extends State<CustomerOrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: "ประวัติคำสั่งซื้อ",
          onTap: () {
            Navigator.pop(context);
          }),
      body: const Center(
        child: Text("NotificationView"),
      ),
    );
  }
}
