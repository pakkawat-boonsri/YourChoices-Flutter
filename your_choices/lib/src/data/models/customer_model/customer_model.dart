// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:your_choices/src/data/models/customer_model/transaction_model/transaction_model.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    final String? type,
    final String? uid,
    final String? email,
    final String? username,
    final String? profileUrl,
    final num? balance,
    final List<TransactionModel>? transaction,
  }) : super(
          uid: uid,
          balance: balance,
          email: email,
          profileUrl: profileUrl,
          transaction: transaction,
          username: username,
          type: type,
        );

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      profileUrl: map['profileUrl'] != null ? map['profileUrl'] as String : null,
      balance: map['balance'] != null ? map['balance'] as num : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }
}
