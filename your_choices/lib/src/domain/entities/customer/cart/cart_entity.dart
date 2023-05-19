// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class CartItemEntity extends Equatable {
  final String? cartId;
  final VendorEntity? vendorEntity;
  final DishesEntity? dishesEntity;
  final int? quantity;
  final String? eatHereOrTakeHome;
  final String? additional;
  final num? totalPrice;

  const CartItemEntity({
    this.cartId,
    this.vendorEntity,
    this.dishesEntity,
    this.quantity,
    this.eatHereOrTakeHome,
    this.additional,
    this.totalPrice,
  });

  @override
  List<Object?> get props => [
        cartId,
        dishesEntity,
        quantity,
        eatHereOrTakeHome,
        additional,
        totalPrice,
      ];

  CartItemEntity copyWith({
    String? cartId,
    VendorEntity? vendorEntity,
    DishesEntity? dishesEntity,
    int? quantity,
    String? eatHereOrTakeHome,
    String? additional,
    num? totalPrice,
  }) {
    return CartItemEntity(
      cartId: cartId ?? this.cartId,
      vendorEntity: vendorEntity ?? this.vendorEntity,
      dishesEntity: dishesEntity ?? this.dishesEntity,
      quantity: quantity ?? this.quantity,
      eatHereOrTakeHome: eatHereOrTakeHome ?? this.eatHereOrTakeHome,
      additional: additional ?? this.additional,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
