// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    final String? orderId,
    final String? customerId,
    final String? customerName,
    final String? restaurantId,
    final VendorEntity? vendorEntity,
    final List<CartItemEntity>? cartItems,
    final Timestamp? createdAt,
    final String? orderTypes,
  }) : super(
          vendorEntity: vendorEntity,
          customerName: customerName,
          orderId: orderId,
          customerId: customerId,
          restaurantId: restaurantId,
          createdAt: createdAt,
          orderTypes: orderTypes,
          cartItems: cartItems,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'restaurantId': restaurantId,
      'vendorEntity': vendorEntity?.toMap(),
      'cartItems': cartItems?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt,
      'orderTypes': orderTypes,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      customerId: map['customerId'] != null ? map['customerId'] as String : null,
      customerName: map['customerName'] != null ? map['customerName'] as String : null,
      restaurantId: map['restaurantId'] != null ? map['restaurantId'] as String : null,
      vendorEntity: map['vendorEntity'] != null ? VendorEntity.fromMap(map['vendorEntity'] as Map<String, dynamic>) : null,
      cartItems: map['cartItems'] != null
          ? List<CartItemEntity>.from(
              (map['cartItems'] as List<dynamic>).map<CartItemEntity?>(
                (x) => CartItemEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      createdAt: map['createdAt'],
      orderTypes: map['orderTypes'] != null ? map['orderTypes'] as String : null,
    );
  }
}
