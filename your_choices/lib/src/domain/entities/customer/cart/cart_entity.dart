// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

class CartItemEntity extends Equatable {
  final String? cartId;
  final String? vendorId;
  final DishesEntity? dishesEntity;
  final int? quantity;
  final String? eatHereOrTakeHome;
  final String? additional;
  final num? basePrice;
  final num? totalPrice;

  const CartItemEntity({
    this.cartId,
    this.vendorId,
    this.dishesEntity,
    this.quantity,
    this.eatHereOrTakeHome,
    this.additional,
    this.basePrice,
    this.totalPrice,
  });

  @override
  List<Object?> get props => [
        cartId,
        vendorId,
        dishesEntity,
        quantity,
        eatHereOrTakeHome,
        additional,
        basePrice,
        totalPrice,
      ];

  CartItemEntity copyWith({
    String? cartId,
    String? vendorId,
    DishesEntity? dishesEntity,
    int? quantity,
    String? eatHereOrTakeHome,
    String? additional,
    num? basePrice,
    num? totalPrice,
    bool? isCheckBoxEnable,
  }) {
    return CartItemEntity(
      cartId: cartId ?? this.cartId,
      vendorId: vendorId ?? this.vendorId,
      dishesEntity: dishesEntity ?? this.dishesEntity,
      quantity: quantity ?? this.quantity,
      eatHereOrTakeHome: eatHereOrTakeHome ?? this.eatHereOrTakeHome,
      additional: additional ?? this.additional,
      basePrice: basePrice ?? this.basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartId': cartId,
      'vendorId': vendorId,
      'dishesEntity': dishesEntity?.toMap(),
      'quantity': quantity,
      'eatHereOrTakeHome': eatHereOrTakeHome,
      'additional': additional,
      'basePrice': basePrice,
      'totalPrice': totalPrice,
    };
  }

  factory CartItemEntity.fromMap(Map<String, dynamic> map) {
    return CartItemEntity(
      cartId: map['cartId'] != null ? map['cartId'] as String : null,
      vendorId: map['vendorId'] != null ? map['vendorId'] as String : null,
      dishesEntity: map['dishesEntity'] != null ? DishesEntity.fromMap(map['dishesEntity'] as Map<String, dynamic>) : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      eatHereOrTakeHome: map['eatHereOrTakeHome'] != null ? map['eatHereOrTakeHome'] as String : null,
      additional: map['additional'] != null ? map['additional'] as String : null,
      basePrice: map['basePrice'] != null ? map['basePrice'] as num : null,
      totalPrice: map['totalPrice'] != null ? map['totalPrice'] as num : null,
    );
  }
}
