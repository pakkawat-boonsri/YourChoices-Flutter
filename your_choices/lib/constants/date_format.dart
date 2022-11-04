import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

class DateConverter {
  static String dateFormat(Timestamp date) {
    final dataDate = date.toDate();
    final dateFormatter = DateFormat("dd MMMM yyyy");
    final timeFormatter = DateFormat("HH:mm");
    String dateConverted =
        "${dateFormatter.formatInBuddhistCalendarThai(dataDate)} เวลา ${timeFormatter.formatInBuddhistCalendarThai(dataDate)}";

    return dateConverted;
  }
}
