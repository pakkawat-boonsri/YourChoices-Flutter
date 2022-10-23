import 'package:flutter/foundation.dart';
import 'package:your_choices/view/restaurant_view/restaurant_view.dart';
import 'package:your_choices/view/transaction_view/transaction_view.dart';

class BottomNavBarViewModel with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final views = [
    const TransactionView(),
    const RestaurantView(),
  ];

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
