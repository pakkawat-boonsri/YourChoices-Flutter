// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String? customerId;
  final Timestamp? date;
  final String? menuName;
  final num? totalPrice;
  final String? resName;
  final String? type;
  final String? name;
  final num? deposit;
  final num? withdraw;

  const TransactionEntity({
    this.id,
    this.customerId,
    this.date,
    this.menuName,
    this.totalPrice,
    this.resName,
    this.type,
    this.name,
    this.deposit,
    this.withdraw,
  });

  @override
  List<Object?> get props => [
        customerId,
        date,
        menuName,
        totalPrice,
        resName,
        type,
        name,
        deposit,
        withdraw,
      ];

  TransactionEntity copyWith({
    String? id,
    String? customerId,
    Timestamp? date,
    String? menuName,
    num? totalPrice,
    String? resName,
    String? type,
    String? name,
    num? deposit,
    num? withdraw,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      menuName: menuName ?? this.menuName,
      totalPrice: totalPrice ?? this.totalPrice,
      resName: resName ?? this.resName,
      type: type ?? this.type,
      name: name ?? this.name,
      deposit: deposit ?? this.deposit,
      withdraw: withdraw ?? this.withdraw,
    );
  }
}
