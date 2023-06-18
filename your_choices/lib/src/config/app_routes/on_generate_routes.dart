import 'package:flutter/material.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/views/customer_side/cart_view/cart_item_detail/cart_item_detail.dart';
import 'package:your_choices/src/presentation/views/customer_side/cart_view/cart_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/cart_view/confirm_cart_items_view/confirm_cart_items_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_order_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/favorite_view/favorite_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/home_view/deposit_view/deposit_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/home_view/withdraw_view/withdraw_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/food_detail_view/food_detail_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/restaurant_detail_view/restaurant_detail_view.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/register_view/register_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/add_menu_view/add_filter_option_view.dart/add_filter_option_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/add_menu_view/add_menu_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/add_menu_view/list_of_filter_option_view/list_of_filter_option_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/menu_view/menu_detail_view/menu_detail_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/menu_view/menu_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/restaurant_infomation_view/edit_restaurant_info_view/edit_restaurant_info_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/restaurant_infomation_view/restaurant_infomation_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/today_order_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/vendor_main_view/vendor_main_view.dart';

import '../../presentation/views/vendor_side/add_menu_view/filter_option_detail_view/filter_option_detail_view.dart';
import '../../presentation/views/vendor_side/menu_view/filter_option_in_menu_detail_view/filter_option_in_menu_detail_view.dart';

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
          if (args is CustomerEntity) {
            return routeBuilder(
              DepositView(
                customerEntity: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.withdrawPage:
        {
          if (args is CustomerEntity) {
            return routeBuilder(
              WithDrawView(
                customerEntity: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.restuarantPageDetail:
        {
          if (args is Map) {
            return routeBuilder(
              RestaurantDetailView(
                customerEntity: args['customerEntity'],
                vendorEntity: args['vendorEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.foodDetailPage:
        {
          if (args is Map) {
            return routeBuilder(
              FoodDetailView(
                customerEntity: args['customerEntity'],
                vendorEntity: args['vendorEntity'],
                dishesEntity: args['dishesEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.cartItemDetailPage:
        {
          if (args is Map) {
            return routeBuilder(
              CartItemDetailView(
                vendorEntity: args['vendorEntity'],
                cartItemEntity: args['cartItemEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }

      case PageConst.customerOrderPage:
        {
          if (args is CustomerEntity) {
            return routeBuilder(CustomerOrderView(
              customerEntity: args,
            ));
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }

      case PageConst.favoritePage:
        {
          if (args is CustomerEntity) {
            return routeBuilder(FavoriteView(
              customerEntity: args,
            ));
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.cartPage:
        {
          if (args is CustomerEntity) {
            return routeBuilder(CartView(
              customerEntity: args,
            ));
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.confirmCartItemPage:
        {
          if (args is Map) {
            return routeBuilder(
              ConfirmCartItemsView(
                customerEntity: args['customerEntity'],
                cartItemEntities: args['cartItemEntities'],
                vendorEntities: args['vendorEntities'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      // vendor route
      case PageConst.todayOrderPage:
        {
          if (args is String) {
            return routeBuilder(
              TodayOrderView(
                uid: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.vendorMainView:
        {
          if (args is String) {
            return routeBuilder(
              VendorMainView(
                uid: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.menuPage:
        {
          if (args is String) {
            return routeBuilder(
              MenuView(
                uid: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.menuDetailPage:
        {
          if (args is Map) {
            return routeBuilder(
              MenuDetailView(
                uid: args['uid'],
                dishesEntity: args['dishesEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.filterOptionInMenuDetailPage:
        {
          if (args is Map) {
            return routeBuilder(
              FilterOptionInMenuDetailView(
                dishesEntity: args['dishesEntity'],
                filterOptionEntity: args['filterOptionEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.listOfFilterOption:
        {
          if (args is Map<String, dynamic>) {
            return routeBuilder(
              ListOfFilterOptionView(
                id: args['id'],
                previousRouteName: args['previousRouteName'],
                dishesEntity: args['dishesEntity'],
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConst.filterOptionDetailPage:
        {
          if (args is FilterOptionEntity) {
            return routeBuilder(
              FilterOptionDetailView(
                filterOptionEntity: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
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
      case PageConst.restaurantInfoPage:
        {
          return args is VendorEntity
              ? routeBuilder(
                  RestaurantInfoView(vendorEntity: args),
                )
              : routeBuilder(
                  const NoPageFound(),
                );
        }
      case PageConst.editResInfoPage:
        {
          return args is VendorEntity
              ? routeBuilder(
                  EditRestaurantInfoView(vendorEntity: args),
                )
              : routeBuilder(
                  const NoPageFound(),
                );
        }
      case PageConst.orderHistoryPage:
        {
          return args is VendorEntity
              ? routeBuilder(
                  OrderHistoryView(vendorEntity: args),
                )
              : routeBuilder(
                  const NoPageFound(),
                );
        }

      case PageConst.addOptionPage:
        {
          return routeBuilder(const AddFilterOptionView());
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

  static const String customerOrderPage = "customerOrderPage";
  static const String favoritePage = "favoritePage";
  static const String cartPage = "cartPage";
  static const String searchboxPage = "searchboxPage";
  static const String cartItemDetailPage = "cartItemDetailPage";
  static const String confirmCartItemPage = "confirmCartItemPage";

  //vendor routes
  static const String vendorMainView = "vendorMainView";
  static const String menuPage = "menuPage";
  static const String menuDetailPage = "menuDetailPage";
  static const String addMenuPage = "addMenuPage";
  static const String filterOptionInMenuDetailPage = "filterOptionInMenuDetailPage";
  static const String restaurantInfoPage = "restaurantInfoPage";
  static const String orderHistoryPage = "orderHistoryPage";
  static const String addOptionPage = "addOptionPage";
  static const String editResInfoPage = "editResInfoPage";
  static const String todayOrderPage = "todayOrderPage";
  static const String filterOptionDetailPage = "filterOptionDetailPage";
  static const String listOfFilterOption = "listOfFilterOption";

  //etc routes

  static const String loginPage = "loginPage";
  static const String registerPage = "registerPage";
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
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
