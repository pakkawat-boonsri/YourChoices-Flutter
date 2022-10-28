import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';

class CustomerViewModel extends ChangeNotifier {
  final customerRepo = CustomerRepository(FirebaseAuth.instance);

  Future<CustomerModel?> getUserData() async{
    return await customerRepo.fetchData();
  }
}
