import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:your_choices/constants/routes.dart';
import 'package:your_choices/view/home_view.dart';
import 'package:your_choices/view/login_view.dart';
import 'package:your_choices/view/register_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YourChoices());
}

class YourChoices extends StatefulWidget {
  const YourChoices({super.key});

  @override
  State<YourChoices> createState() => _YourChoicesState();
}

class _YourChoicesState extends State<YourChoices> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF34312f),
      ),
      title: "YourChoices",
      // FirebaseAuthProvider().handleUserLogin(),
      home: HomeView(),
      routes: {
        loginRoutes: (context) => const LoginView(),
        registerRoutes: (context) => const RegisterView(),
      },
    );
  }
}
