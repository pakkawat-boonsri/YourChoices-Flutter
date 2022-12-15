import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/login_screen/view_models/login_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (context, value, child) {
            return ElevatedButton(
              onPressed: () {
                value.signOut(context);
              },
              child: const Text("Sign Out"),
            );
          },
        ),
      ),
    );
  }
}