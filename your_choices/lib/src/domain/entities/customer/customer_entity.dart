import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/transaction_entity.dart';

class CustomerEntity extends Equatable {
  final String? uid;
  final String? email;
  final String? username;
  final String? profileUrl;
  final num? balance;
  final String? type;
  final List<TransactionEntity>? transaction;

  final String? password;
  final String? otherUid;

  const CustomerEntity({
    this.type,
    this.uid,
    this.username,
    this.profileUrl,
    this.transaction,
    this.password,
    this.otherUid,
    this.email,
    this.balance,
  });

  @override
  List<Object?> get props => [
        type,
        uid,
        username,
        profileUrl,
        transaction,
        password,
        otherUid,
        email,
        balance,
      ];
}
