import 'dart:io';

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
  final List<DishesEntity>? dishes;

  //Not collect in db
  final File? imageFile;
  final File? resImageFile;
  final String? password;
  final String? otherUid;

  const VendorEntity({
    this.type,
    this.uid,
    this.resName,
    this.resProfileUrl,
    this.isActive,
    this.onQueue,
    this.description,
    this.totalPriceSell,
    this.dishes,
    this.email,
    this.username,
    this.profileUrl,
    this.imageFile,
    this.resImageFile,
    this.password,
    this.otherUid,
  });

  @override
  List<Object?> get props => [
        uid,
        type,
        resName,
        resProfileUrl,
        isActive,
        onQueue,
        description,
        totalPriceSell,
        dishes,
        email,
        username,
        profileUrl,
        imageFile,
        resImageFile,
        password,
        otherUid,
      ];
}
