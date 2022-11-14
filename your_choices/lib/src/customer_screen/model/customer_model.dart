import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/utilities/check_double_value.dart';


// ignore: must_be_immutable
class CustomerModel extends Equatable {
  String? username;
  double? balance;
  String? imgAvatar;
  String? role;
  List<Transaction>? transaction;

  CustomerModel(
      {this.username,
      this.balance,
      this.imgAvatar,
      this.role,
      this.transaction});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    balance = checkDouble(json['balance']);
    imgAvatar = json['imgAvatar'];
    role = json['role'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['balance'] = balance;
    data['imgAvatar'] = imgAvatar;
    data['role'] = role;
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [
        username,
        balance,
        imgAvatar,
        role,
        transaction,
      ];
}

// ignore: must_be_immutable
class Transaction extends Equatable {
  Timestamp? date;
  String? menuName;
  double? totalPrice;
  String? resName;
  String? type;
  String? name;
  int? deposit;
  int? withdraw;

  Transaction(
      {this.date,
      this.menuName,
      this.totalPrice,
      this.resName,
      this.type,
      this.name,
      this.deposit,
      this.withdraw});

  Transaction.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    menuName = json['menuName'];
    totalPrice = checkDouble(json['totalPrice']);
    resName = json['resName'];
    type = json['type'];
    name = json['name'];
    deposit = json['deposit'];
    withdraw = json['withdraw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['menuName'] = menuName;
    data['totalPrice'] = totalPrice;
    data['resName'] = resName;
    data['type'] = type;
    data['name'] = name;
    data['deposit'] = deposit;
    data['withdraw'] = withdraw;
    return data;
  }

  @override
  List<Object?> get props =>
      [date, menuName, totalPrice, resName, type, name, deposit, withdraw];
}
