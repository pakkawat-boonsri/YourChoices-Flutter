import 'package:flutter/material.dart';

class RestuarantView extends StatefulWidget {
  const RestuarantView({super.key});

  @override
  State<RestuarantView> createState() => _RestuarantViewState();
}

class _RestuarantViewState extends State<RestuarantView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("RestuarantView"),
      ),
    );
  }
}
