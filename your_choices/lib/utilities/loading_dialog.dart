import 'package:flutter/material.dart';

Future<void> loadingDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        );
      },
    );
