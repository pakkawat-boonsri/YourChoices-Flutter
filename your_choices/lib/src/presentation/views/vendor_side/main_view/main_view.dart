import 'package:flutter/material.dart';

class VendorMainView extends StatefulWidget {
  final String uid;
  const VendorMainView({super.key, required this.uid});

  @override
  State<VendorMainView> createState() => _VendorMainViewState();
}

class _VendorMainViewState extends State<VendorMainView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Vendor Side"),
      ),
    );
  }
}
