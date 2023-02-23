import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final Timestamp? date;
  final String? menuName;
  final num? totalPrice;
  final String? resName;
  final String? type;
  final String? name;
  final num? deposit;
  final num? withdraw;

  const TransactionEntity({
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
        date,
        menuName,
        totalPrice,
        resName,
        type,
        name,
        deposit,
        withdraw,
      ];
}
