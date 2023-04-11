import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/presentation/blocs/add_add_ons/add_add_ons_cubit.dart';
import 'package:your_choices/src/presentation/blocs/add_filter_in_menu/add_filter_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/add_filter_option/add_filter_option_cubit.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/blocs/filter_option/filter_options_cubit.dart';
import 'package:your_choices/src/presentation/blocs/filter_option_in_menu/filter_option_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/menu/menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor/vendor_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_main_view/customer_main_view.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/vendor_main_view/vendor_main_view.dart';
import 'package:your_choices/src/restaurant_screen/repository/restaurant_repo.dart';
import 'package:your_choices/src/restaurant_screen/view_model/bloc/restaurant_bloc.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

import 'firebase_options.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
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
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<CustomerCubit>()),
        BlocProvider(create: (_) => di.sl<VendorCubit>()),
        BlocProvider(create: (_) => di.sl<MenuCubit>()),
        BlocProvider(create: (_) => di.sl<FilterOptionCubit>()),
        BlocProvider(create: (_) => di.sl<AddFilterOptionCubit>()),
        BlocProvider(create: (_) => di.sl<AddAddOnsCubit>()),
        BlocProvider(create: (_) => di.sl<AddFilterInMenuCubit>()),
        BlocProvider(create: (_) => di.sl<FilterOptionInMenuCubit>()),
        RepositoryProvider(create: (context) => RestaurantRepository()),
        BlocProvider(
          create: (context) => RestaurantBloc(
              RepositoryProvider.of<RestaurantRepository>(context)),
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
            return BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthInitial) {
                  loadingDialog(context);
                }
              },
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
