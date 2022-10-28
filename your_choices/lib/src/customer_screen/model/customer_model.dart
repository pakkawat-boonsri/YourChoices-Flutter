// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

CustomerModel customerModelFromJson(String str) => CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    required this.username,
    required  this.balance,
    required this.imgAvatar,
    required this.role,
    required this.transaction,
  });

  String username;
  double balance;
  String imgAvatar;
  String role;
  List<Transaction> transaction;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    username: json["username"],
    balance: json["balance"].toDouble(),
    imgAvatar: json["imgAvatar"],
    role: json["role"],
    transaction: List<Transaction>.from(json["transaction"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "balance": balance,
    "imgAvatar": imgAvatar,
    "role": role,
    "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
  };
}

class Transaction {
  Transaction({
    required this.date,
    required  this.menuName,
    required  this.totalPrice,
    required  this.resName,
    required  this.type,
    required  this.name,
    required  this.deposit,
    required  this.withdraw,
  });

  String? date;
  String? menuName;
  double? totalPrice;
  String? resName;
  String? type;
  String? name;
  int? deposit;
  int? withdraw;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    date: (json["date"] == null) ? null : json['date'],
    menuName: (json["menuName"] == null) ? null : json["menuName"],
    totalPrice: (json["totalPrice"] == null) ? null : json["totalPrice"].toDouble(),
    resName: (json["res_name"] == null) ? null : json["res_name"],
    type: (json["type"] == null) ? null : json['type'],
    name: (json["name"] == null) ? null : json["name"],
    deposit: (json["deposit"] == null) ? null : json["deposit"],
    withdraw: (json["withdraw"] == null) ? null : json["withdraw"],
  );

  Map<String, dynamic> toJson() => {
    "date": date == null ? null : date,
    "menuName": menuName == null ? null : menuName,
    "totalPrice": totalPrice == null ? null : totalPrice,
    "res_name": resName == null ? null : resName,
    "type": type == null ? null : type,
    "name": name == null ? null : name,
    "deposit": deposit == null ? null : deposit,
    "withdraw": withdraw == null ? null : withdraw,
  };
}
