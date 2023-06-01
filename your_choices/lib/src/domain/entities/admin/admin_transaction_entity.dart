// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AdminTransactionEntity extends Equatable {
  final String? id;
  final Timestamp? date;
  final String? transactionType;
  final String? customerName;
  final num? deposit;
  final num? withdraw;

  const AdminTransactionEntity({
    this.id,
    this.date,
    this.transactionType,
    this.customerName,
    this.deposit,
    this.withdraw,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        transactionType,
        customerName,
        deposit,
        withdraw,
      ];

  AdminTransactionEntity copyWith({
    String? id,
    Timestamp? date,
    String? transactionType,
    String? customerName,
    num? deposit,
    num? withdraw,
  }) {
    return AdminTransactionEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      transactionType: transactionType ?? this.transactionType,
      customerName: customerName ?? this.customerName,
      deposit: deposit ?? this.deposit,
      withdraw: withdraw ?? this.withdraw,
    );
  }
}
