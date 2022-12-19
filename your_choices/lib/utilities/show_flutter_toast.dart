import 'package:fluttertoast/fluttertoast.dart';

void showFlutterToast(String massage) {
  Fluttertoast.showToast(
    msg: massage,
    fontSize: 16,
    toastLength: Toast.LENGTH_LONG,
  );
}
