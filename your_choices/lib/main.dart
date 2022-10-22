import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/constants/routes.dart';
import 'package:your_choices/view/login_view/login_view.dart';
import 'package:your_choices/view/register_view/register_view.dart';
import 'package:your_choices/view_model/login_view_model/login_view_model.dart';
import 'package:your_choices/view_model/bottom_nav_view_model/bottom_nav_bar_view_model.dart';
import 'package:your_choices/view_model/register_view_model/register_view_model.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF34312f),
        ),
        title: "YourChoices",
        home: Consumer<LoginViewModel>(
          builder: (context, loginViewModel, child) {
            return loginViewModel.handleUserLogin();
          },
        ),
        routes: {
          loginRoutes: (context) => const LoginView(),
          registerRoutes: (context) => const RegisterView(),
        },
      ),
    );
  }
}
