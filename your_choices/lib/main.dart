import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/bottom_navbar_screen/view/bottom_nav_bar.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';
import 'package:your_choices/src/customer_screen/view_model/customer_view_model.dart';
import 'package:your_choices/src/login_screen/views/login_view.dart';
import 'package:your_choices/src/login_screen/view_models/login_view_model.dart';
import 'package:your_choices/src/bottom_navbar_screen/view_model/bottom_nav_bar_view_model.dart';
import 'package:your_choices/src/register_screen/view_model/register_view_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
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
          create: (context) => BottomNavBarViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerViewModel(),
        ),
        RepositoryProvider(
          create: (context) => CustomerRepository(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF34312f),
        ),
        title: "YourChoices",
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const BottomNavBarView();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}
