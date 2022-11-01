import 'package:flutter/material.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';

class CustomerViewModel extends ChangeNotifier {
  CustomerModel? model;

  CustomerRepository repo = CustomerRepository();

  CustomerViewModel() {
    repo.fetchData();
  }

  Future<CustomerModel?> fetchData() async {
    final data = await CustomerRepository().fetchData();
    model = data;
    return null;
  }
}
