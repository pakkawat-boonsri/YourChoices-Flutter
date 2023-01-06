import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';

class ProfileView extends StatelessWidget {
  final String uid;
  const ProfileView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          context.read<AuthCubit>().loggingOut();
        },
        child: const Text("Sign Out"),
      )),
    );
  }
}
