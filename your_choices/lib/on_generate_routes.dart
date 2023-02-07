import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/views/customer_side/home_view/deposit_view/deposit_view.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/register_view/register_view.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
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
      // case PageConst.withdrawPage:
      //   {
      //     return routeBuilder(const WithDrawView());
      //   }
      // case PageConst.registerPage:
      // {
      //   return routeBuilder(const RestaurantView());
      // }
      // case PageConst.restuarantPageDetail:
      // {
      //   return routeBuilder( RestaurantDetailView(model: args,));
      // }
      // case PageConst.foodDetailPage:
      // {
      //   return routeBuilder(const FoodDetailView());
      // }
      // case PageConst.notificationPage:
      // {
      //   return routeBuilder(const NotificationView());
      // }
      // case PageConst.profilePage:
      // {
      //   return routeBuilder(const ProfileView());
      // }
      default:
        {
          const NoPageFound();
        }
    }
    return null;
  }
}

class PageConst {
  static const String loginPage = "loginPage";
  static const String registerPage = "registerPage";
  static const String transactionPage = "transactionPage";
  static const String depositPage = "depositPage";
  static const String withdrawPage = "withdrawPage";
  static const String restuarantListPage = "restuarantListPage";
  static const String restuarantPageDetail = "restuarantPageDetail";
  static const String foodDetailPage = "foodDetailPage";
  static const String notificationPage = "notificationPage";
  static const String profilePage = "profilePage";
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("No Page Found Page"),
        ),
      ),
    );
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
