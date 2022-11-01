import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateConverter {
  static String dateFormat(Timestamp date) {
    final dataDate = date.toDate();
    final dateFormatter = DateFormat("dd MMMM yyyy");
    final timeFormatter = DateFormat("HH:mm");
    String dateConverted =
        "${dateFormatter.format(dataDate)} เวลา ${timeFormatter.format(dataDate)}";

    return dateConverted;
  }
}
