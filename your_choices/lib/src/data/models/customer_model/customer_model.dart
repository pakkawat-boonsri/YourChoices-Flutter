import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';

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
      profileUrl: snapshot['profileUrl'],
      email: snapshot['email'],
      balance: snapshot['balance'],
      uid: snapshot['uid'],
      transaction: const <TransactionEntity>[],
    );
  }

  Map<String, dynamic> modeltoJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['type'] = type;
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    data['balance'] = balance;
    data['uid'] = uid;
    return data;
  }
}
