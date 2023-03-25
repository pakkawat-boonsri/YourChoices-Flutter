// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../filter_options/filter_option_entity.dart';

class DishesEntity extends Equatable {
  final String? dishesId;
  final Timestamp? createdAt;
  final bool? isActive;
  final String? menuName;
  final String? menuImg;
  final num? menuPrice;
  final String? menuDescription;
  final List<FilterOptionEntity>? filterOption;

  final File? disheImageFile;

  const DishesEntity({
    this.disheImageFile,
    this.isActive,
    this.dishesId,
    this.createdAt,
    this.menuName,
    this.menuImg,
    this.menuPrice,
    this.menuDescription,
    this.filterOption,
  });

  @override
  List<Object?> get props => [
        disheImageFile,
        isActive,
        dishesId,
        createdAt,
        menuName,
        menuImg,
        menuPrice,
        menuDescription,
        filterOption,
      ];

  DishesEntity copyWith({
    String? dishesId,
    Timestamp? createdAt,
    bool? isActive,
    String? menuName,
    String? menuImg,
    num? menuPrice,
    String? menuDescription,
    List<FilterOptionEntity>? filterOption,
    File? disheImageFile,
  }) {
    return DishesEntity(
      dishesId: dishesId ?? this.dishesId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      menuName: menuName ?? this.menuName,
      menuImg: menuImg ?? this.menuImg,
      menuPrice: menuPrice ?? this.menuPrice,
      menuDescription: menuDescription ?? this.menuDescription,
      filterOption: filterOption ?? this.filterOption,
      disheImageFile: disheImageFile ?? this.disheImageFile,
    );
  }
}
