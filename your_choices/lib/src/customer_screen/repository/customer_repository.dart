import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';

class CustomerRepository {
  CustomerRepository(this.auth);

  FirebaseAuth auth;
  final db = FirebaseFirestore.instance;

  Future<CustomerModel?> fetchData() async {
    final data = db.collection("customer").doc(auth.currentUser!.uid);
    final snapshot = await data.get();

    if (snapshot.exists) {
      return CustomerModel.fromJson(snapshot.data()!);
    }
    return null;
  }
}
