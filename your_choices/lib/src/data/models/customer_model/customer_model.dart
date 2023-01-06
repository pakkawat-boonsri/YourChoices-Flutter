import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/data/models/customer_model/transaction_model.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    final String? type,
    final String? uid,
    final String? email,
    final String? username,
    final String? profileUrl,
    final num? balance,
    final List<TransactionEntity>? transaction,
  }) : super(
          uid: uid,
          balance: balance,
          email: email,
          profileUrl: profileUrl,
          transaction: transaction,
          username: username,
          type: type,
        );

  factory CustomerModel.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CustomerModel(
      username: snapshot['username'],
      type: snapshot['type'],
      transaction: List.from(
        snapshot['transaction'].map(
          (x) => TransactionModel.fromJson(x),
        ),
      ),
      profileUrl: snapshot['profileUrl'],
      email: snapshot['email'],
      balance: snapshot['balance'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['type'] = type;
    data['transaction'] = transaction;
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    data['balance'] = balance;
    data['uid'] = uid;
    return data;
  }
}
