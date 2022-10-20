import 'package:flutter/foundation.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isCustomerCheck = false;
  bool _isRestaurantCheck = false;
  bool _isLoading = false;
  bool _isClick = false;

  bool get getIsLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
  }

  bool get getIsClick => _isClick;

  setIsClick(bool value) {
    _isClick = value;
  }

  bool get getCustomerCheck => _isCustomerCheck;

  setCustomerCheck(bool checked) {
    _isCustomerCheck = checked;
    notifyListeners();
  }

  bool get getRestaurantCheck => _isRestaurantCheck;

  setRestaurantCheck(bool checked) {
    _isRestaurantCheck = checked;
    notifyListeners();
  }
}
