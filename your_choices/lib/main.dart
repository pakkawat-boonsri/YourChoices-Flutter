import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/customer_screen/bloc/customer_bloc/customer_bloc.dart';
import 'package:your_choices/src/customer_screen/bloc/deposit_bloc/bloc/deposit_bloc.dart';
import 'package:your_choices/src/customer_screen/bloc/withdraw_bloc/bloc/withdraw_bloc.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';
import 'package:your_choices/src/login_screen/view_models/login_view_model.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/main_view/main_view.dart';
import 'package:your_choices/src/register_screen/view_model/register_view_model.dart';
import 'package:your_choices/src/restaurant_screen/repository/restaurant_repo.dart';
import 'package:your_choices/src/restaurant_screen/view_model/bloc/restaurant_bloc.dart';

import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
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
        RepositoryProvider(
          create: (context) => CustomerRepository(),
        ),
        BlocProvider(
          create: (context) => CustomerBloc(
            RepositoryProvider.of<CustomerRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => DepositBloc(),
        ),
        BlocProvider(
          create: (context) => WithdrawBloc(),
        ),
        RepositoryProvider(
          create: (context) => RestaurantRepository(),
        ),
        BlocProvider(
          create: (context) => RestaurantBloc(
            RepositoryProvider.of<RestaurantRepository>(context),
          ),
        ),
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
              return const MainView();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}
