// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'dishes_menu/dishes_entity.dart';

class VendorEntity extends Equatable {
  final String? uid;
  final String? email;
  final String? username;
  final String? profileUrl;
  final String? type;
  final String? resName;
  final String? resProfileUrl;
  final bool? isActive;
  final num? onQueue;
  final String? description;
  final num? totalPriceSell;
  final String? restaurantType;
  final Timestamp? accountCreatedWhen;
  final List<DishesEntity>? dishes;

  //Not collect in db
  final File? imageFile;
  final File? resImageFile;
  final String? password;
  final String? otherUid;

  const VendorEntity({
    this.uid,
    this.email,
    this.username,
    this.profileUrl,
    this.type,
    this.resName,
    this.resProfileUrl,
    this.isActive,
    this.onQueue,
    this.description,
    this.totalPriceSell,
    this.restaurantType,
    this.accountCreatedWhen,
    this.dishes,
    this.imageFile,
    this.resImageFile,
    this.password,
    this.otherUid,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        profileUrl,
        type,
        resName,
        resProfileUrl,
        isActive,
        onQueue,
        description,
        totalPriceSell,
        restaurantType,
        accountCreatedWhen,
        dishes,
        imageFile,
        resImageFile,
        password,
        otherUid,
      ];

  VendorEntity copyWith({
    String? uid,
    String? email,
    String? username,
    String? profileUrl,
    String? type,
    String? resName,
    String? resProfileUrl,
    bool? isActive,
    num? onQueue,
    String? description,
    num? totalPriceSell,
    String? restaurantType,
    Timestamp? accountCreatedWhen,
    List<DishesEntity>? dishes,
    File? imageFile,
    File? resImageFile,
    String? password,
    String? otherUid,
  }) {
    return VendorEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      type: type ?? this.type,
      resName: resName ?? this.resName,
      resProfileUrl: resProfileUrl ?? this.resProfileUrl,
      isActive: isActive ?? this.isActive,
      onQueue: onQueue ?? this.onQueue,
      description: description ?? this.description,
      totalPriceSell: totalPriceSell ?? this.totalPriceSell,
      restaurantType: restaurantType ?? this.restaurantType,
      accountCreatedWhen: accountCreatedWhen ?? this.accountCreatedWhen,
      dishes: dishes ?? this.dishes,
      imageFile: imageFile ?? this.imageFile,
      resImageFile: resImageFile ?? this.resImageFile,
      password: password ?? this.password,
      otherUid: otherUid ?? this.otherUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'profileUrl': profileUrl,
      'type': type,
      'resName': resName,
      'resProfileUrl': resProfileUrl,
      'isActive': isActive,
      'onQueue': onQueue,
      'description': description,
      'totalPriceSell': totalPriceSell,
      'restaurantType': restaurantType,
      'accountCreatedWhen': accountCreatedWhen,
      'dishes': dishes?.map((x) => x.toMap()).toList(),
    };
  }

  factory VendorEntity.fromMap(Map<String, dynamic> map) {
    return VendorEntity(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      profileUrl: map['profileUrl'] != null ? map['profileUrl'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      resName: map['resName'] != null ? map['resName'] as String : null,
      resProfileUrl: map['resProfileUrl'] != null ? map['resProfileUrl'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      onQueue: map['onQueue'] != null ? map['onQueue'] as num : null,
      description: map['description'] != null ? map['description'] as String : null,
      totalPriceSell: map['totalPriceSell'] != null ? map['totalPriceSell'] as num : null,
      restaurantType: map['restaurantType'] != null ? map['restaurantType'] as String : null,
      accountCreatedWhen:
          map['accountCreatedWhen'] ,
      dishes: map['dishes'] != null
          ? List<DishesEntity>.from(
              (map['dishes'] as List<dynamic>).map<DishesEntity?>(
                (x) => DishesEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      
    );
  }
}
