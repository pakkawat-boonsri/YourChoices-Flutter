import 'package:flutter/cupertino.dart';

class LoginViewModel extends ChangeNotifier {
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
}
