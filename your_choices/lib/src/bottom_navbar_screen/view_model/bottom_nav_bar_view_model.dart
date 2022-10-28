import 'package:flutter/foundation.dart';
import 'package:your_choices/src/restaurant_screen/views/restaurant_view.dart';
import 'package:your_choices/src/customer_screen/views/customer_view.dart';

class BottomNavBarViewModel with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final views = [
    const CustomerView(),
    const RestaurantView(),
  ];

  setcurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
