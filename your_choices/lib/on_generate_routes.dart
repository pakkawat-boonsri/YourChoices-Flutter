import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/views/customer_side/home_view/deposit_view/deposit_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/home_view/withdraw_view/withdraw_view.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/register_view/register_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/add_menu_view/add_menu_view.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //customer route
      case PageConst.loginPage:
        {
          return routeBuilder(const LoginView());
        }
      case PageConst.registerPage:
        {
          return routeBuilder(const RegisterView());
        }
      case PageConst.depositPage:
        {
          return routeBuilder(const DepositView());
        }
      case PageConst.withdrawPage:
        {
          if (args is String) {
            return routeBuilder(WithDrawView(
              uid: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      // vendor route
      case PageConst.addMenuPage:
        {
          if (args is String) {
            return routeBuilder(
              AddMenuView(
                uid: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      default:
        {
          routeBuilder(const NoPageFound());
        }
    }
    return routeBuilder(const NoPageFound());
  }
}

class PageConst {
  //customer routes
  static const String transactionPage = "transactionPage";
  static const String depositPage = "depositPage";
  static const String withdrawPage = "withdrawPage";
  static const String restuarantListPage = "restuarantListPage";
  static const String restuarantPageDetail = "restuarantPageDetail";
  static const String foodDetailPage = "foodDetailPage";
  static const String profilePage = "profilePage";

  //vendor routes
  static const String addMenuPage = "addMenuPage";

  //etc routes

  static const String loginPage = "loginPage";
  static const String registerPage = "registerPage";
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Page Found Page"),
      ),
    );
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
