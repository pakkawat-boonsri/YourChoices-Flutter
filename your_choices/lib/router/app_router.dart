import 'package:flutter/material.dart';
import 'package:your_choices/router/routes.dart';
import 'package:your_choices/src/bottom_navbar_screen/view/bottom_nav_bar.dart';
import 'package:your_choices/src/login_screen/views/login_view.dart';
import 'package:your_choices/src/register_screen/views/register_view.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const RegisterView(),
        );
      case customerPage:
        return MaterialPageRoute(
          builder: (context) => const BottomNavBarView(),
        );
      case restaurantPage:
        return MaterialPageRoute(
          builder: (context) => const BottomNavBarView(),
        );
      default:
        return null;
    }
  }
}
