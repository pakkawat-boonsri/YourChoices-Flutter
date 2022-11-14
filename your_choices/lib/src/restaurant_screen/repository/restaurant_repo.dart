import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

class RestaurantRepository {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  Future<List<RestaurantModel>?> fetchRestaurantData() async {
    final data = await db.collection("restuarant").get();
    final snapshot = data.docs
        .map(
          (e) => RestaurantModel.fromJson(
            e.data(),
          ),
        )
        .toList();

    return snapshot;
  }

  updateData(bool isChecked, int index) async {
    final value =
        await db.collection("restuarant").doc("DO0DEHwzubAM6Z7uYnXj").get();

    final data = value.data();

    final foods =
        data!['Foods'].map((item) => item as Map<String, dynamic>).toList();

    final food = foods[index];

    food['isChecked'] = isChecked;

    await db.collection("restuarant").doc("DO0DEHwzubAM6Z7uYnXj").update(data);
  }
}
