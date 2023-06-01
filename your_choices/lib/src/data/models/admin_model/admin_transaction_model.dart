// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';

class AdminTransactionModel extends AdminTransactionEntity {
  const AdminTransactionModel({
    super.id,
    super.date,
    super.transactionType,
    super.customerName,
    super.deposit,
    super.withdraw,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'transactionType': transactionType,
      'customerName': customerName,
      'deposit': deposit,
      'withdraw': withdraw,
    };
  }

  factory AdminTransactionModel.fromMap(Map<String, dynamic> map) {
    return AdminTransactionModel(
      id: map['id'] != null ? map['id'] as String : null,
      date: map['date'],
      transactionType: map['transactionType'] != null ? map['transactionType'] as String : null,
      customerName: map['customerName'] != null ? map['customerName'] as String : null,
      deposit: map['deposit'] != null ? map['deposit'] as num : null,
      withdraw: map['withdraw'] != null ? map['withdraw'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminTransactionModel.fromJson(String source) =>
      AdminTransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
