// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class OrderEntity extends Equatable {
  final String? orderId;
  final String? customerId;
  final String? customerName;
  final String? restaurantId;
  final VendorEntity? vendorEntity;
  final List<CartItemEntity>? cartItems;
  final Timestamp? createdAt;
  final String? orderTypes;

  const OrderEntity({
    this.orderId,
    this.customerId,
    this.customerName,
    this.restaurantId,
    this.vendorEntity,
    this.cartItems,
    this.createdAt,
    this.orderTypes,
  });

  @override
  List<Object?> get props => [
        orderId,
        customerId,
        restaurantId,
        cartItems,
        createdAt,
        orderTypes,
        customerName,
        vendorEntity,
      ];

  OrderEntity copyWith({
    String? orderId,
    String? customerId,
    String? customerName,
    String? restaurantId,
    VendorEntity? vendorEntity,
    List<CartItemEntity>? cartItems,
    Timestamp? createdAt,
    String? orderTypes,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      restaurantId: restaurantId ?? this.restaurantId,
      vendorEntity: vendorEntity ?? this.vendorEntity,
      cartItems: cartItems ?? this.cartItems,
      createdAt: createdAt ?? this.createdAt,
      orderTypes: orderTypes ?? this.orderTypes,
    );
  }
}
