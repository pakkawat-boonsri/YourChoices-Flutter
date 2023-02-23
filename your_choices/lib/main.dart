import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor/vendor_cubit.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/vendor_main_view/vendor_main_view.dart';
import 'package:your_choices/src/restaurant_screen/repository/restaurant_repo.dart';
import 'package:your_choices/src/restaurant_screen/view_model/bloc/restaurant_bloc.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_main_view/customer_main_view.dart';
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
        BlocProvider(
          create: (_) => di.sl<AuthCubit>()..appStarted(context),
        ),
        BlocProvider(
          create: (_) => di.sl<CredentialCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CustomerCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<VendorCubit>(),
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
        onGenerateRoute: OnGenerateRoute.route,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF34312f),
        ),
        title: "YourChoices",
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  if (state.type == "restaurant") {
                    return VendorMainView(uid: state.uid);
                  } else {
                    
                    return CustomerMainView(uid: state.uid);
                  }
                } else {
                  return const LoginView();
                }
              },
            );
          }
        },
      ),
    );
  }
}
