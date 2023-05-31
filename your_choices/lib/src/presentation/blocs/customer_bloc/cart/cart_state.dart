// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<VendorEntity> vendorEntities;
  final List<CartItemEntity> cartItems;
  const CartState({
    required this.vendorEntities,
    required this.cartItems,
  });

  @override
  List<Object> get props => [
        vendorEntities,
        cartItems,
      ];

  CartState copyWith({
    List<VendorEntity>? vendorEntities,
    List<CartItemEntity>? cartItems,
  }) {
    return CartState(
      vendorEntities: vendorEntities ?? this.vendorEntities,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
