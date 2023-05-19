// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
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
  final String? depositAmount;
  final String? withdrawAmount;

  const CustomerEntity({
    this.uid,
    this.email,
    this.username,
    this.profileUrl,
    this.balance,
    this.type,
    this.transaction,
    this.imageFile,
    this.password,
    this.otherUid,
    this.depositAmount,
    this.withdrawAmount,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        profileUrl,
        balance,
        type,
        transaction,
        imageFile,
        password,
        otherUid,
        depositAmount,
        withdrawAmount,
      ];

  CustomerEntity copyWith({
    String? uid,
    String? email,
    String? username,
    String? profileUrl,
    num? balance,
    String? type,
    List<TransactionEntity>? transaction,
    String? depositAmount,
    String? withdrawAmount,
  }) {
    return CustomerEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      transaction: transaction ?? this.transaction,
      depositAmount: depositAmount ?? this.depositAmount,
      withdrawAmount: withdrawAmount ?? this.withdrawAmount,
    );
  }



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'profileUrl': profileUrl,
      'balance': balance,
      'type': type,
      'depositAmount': depositAmount,
      'withdrawAmount': withdrawAmount,
    };
  }

  factory CustomerEntity.fromMap(Map<String, dynamic> map) {
    return CustomerEntity(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      profileUrl: map['profileUrl'] != null ? map['profileUrl'] as String : null,
      balance: map['balance'] != null ? map['balance'] as num : null,
      type: map['type'] != null ? map['type'] as String : null,
      depositAmount: map['depositAmount'] != null ? map['depositAmount'] as String : null,
      withdrawAmount: map['withdrawAmount'] != null ? map['withdrawAmount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerEntity.fromJson(String source) => CustomerEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
