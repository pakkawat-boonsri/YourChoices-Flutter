import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';

class CustomerEntity extends Equatable {
  final String? uid;
  final String? email;
  final String? username;
  final String? profileUrl;
  final num? balance;
  final String? type;
  final List<TransactionEntity>? transaction;

  final File? imageFile;
  final String? password;
  final String? otherUid;

  const CustomerEntity({
    this.imageFile,
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
        imageFile,
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
