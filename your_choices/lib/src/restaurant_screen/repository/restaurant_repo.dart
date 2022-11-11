import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

class RestaurantRepository {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  Future<RestaurantModel?> fetchRestaurantData() async {
    final data =
        await db.collection("restaurant").doc("DO0DEHwzubAM6Z7uYnXj").get();

    if (data.exists) {
      return RestaurantModel.fromJson(data.data()!);
    } else {
      return null;
    }
  }
}
