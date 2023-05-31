// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    final String? id,
    final Timestamp? date,
    final String? menuName,
    final num? totalPrice,
    final String? resName,
    final String? type,
    final String? name,
    final num? deposit,
    final num? withdraw,
  }) : super(
          id: id,
          date: date,
          deposit: deposit,
          menuName: menuName,
          name: name,
          resName: resName,
          totalPrice: totalPrice,
          type: type,
          withdraw: withdraw,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'menuName': menuName,
      'totalPrice': totalPrice,
      'resName': resName,
      'type': type,
      'name': name,
      'deposit': deposit,
      'withdraw': withdraw,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] != null ? map['id'] as String : null,
      date: map['date'],
      menuName: map['menuName'] != null ? map['menuName'] as String : null,
      totalPrice: map['totalPrice'] != null ? map['totalPrice'] as num : null,
      resName: map['resName'] != null ? map['resName'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      deposit: map['deposit'] != null ? map['deposit'] as num : null,
      withdraw: map['withdraw'] != null ? map['withdraw'] as num : null,
    );
  }
}
