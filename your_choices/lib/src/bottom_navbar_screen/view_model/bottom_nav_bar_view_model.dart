import 'package:flutter/foundation.dart';
import 'package:your_choices/src/favorite_screen/view/favorite_view.dart';
import 'package:your_choices/src/notification_screen/views/notification_view.dart';
import 'package:your_choices/src/porfile_screen/views/profile_view.dart';
import 'package:your_choices/src/restaurant_screen/views/restaurant_list_view.dart';
import 'package:your_choices/src/customer_screen/views/customer_view.dart';

class BottomNavBarViewModel with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final views = [
    const CustomerView(),
    const RestaurantView(),
    const FavoriteView(),
    const NotificationView(),
    const ProfileView(),
  ];

  setcurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
