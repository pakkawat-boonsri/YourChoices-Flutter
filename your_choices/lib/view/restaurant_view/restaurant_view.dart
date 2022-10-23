import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/view_model/login_view_model/login_view_model.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
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
                child: const Text("Sign Out"));
          },
        ),
      ),
    );
  }
}
