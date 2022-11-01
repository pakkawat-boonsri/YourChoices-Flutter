import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';

class CustomerRepository {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  Future<CustomerModel?> fetchData() {
    return db
        .collection("customer")
        .doc(auth)
        .get()
        .then((value) => CustomerModel.fromJson(value.data()!));
  }
}
