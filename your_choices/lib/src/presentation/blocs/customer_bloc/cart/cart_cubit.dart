// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/restaurant/send_confirm_order_to_restaurant_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final SendConfirmOrderToRestaurantUseCase sendConfirmOrderToRestaurantUseCase;
  CartCubit({
    required this.sendConfirmOrderToRestaurantUseCase,
  }) : super(
          const CartState(
            vendorEntities: [],
            cartItems: [],
          ),
        );

  Future<void> sendConfirmOrderToRestaurant(ConfirmOrderEntity confirmOrderEntity) async {
    try {
      await sendConfirmOrderToRestaurantUseCase.call(confirmOrderEntity);
    } catch (e) {
      log("asdasd ${e.toString()}");
    }
  }

  void clearCart() {
    emit(state.copyWith(cartItems: [], vendorEntities: []));
  }

  void addItemToCart({
    required VendorEntity vendorEntity,
    required CartItemEntity cartItemEntity,
  }) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    final currentCartItemEntity = List<CartItemEntity>.from(state.cartItems);

    if (!currentVendorEntities.contains(vendorEntity)) {
      currentVendorEntities.add(vendorEntity);
    }

    bool found = false;
    for (int i = 0; i < currentCartItemEntity.length; i++) {
      CartItemEntity item = currentCartItemEntity[i];
      if (item.cartId == cartItemEntity.cartId &&
          item.basePrice == cartItemEntity.basePrice &&
          item.dishesEntity == cartItemEntity.dishesEntity &&
          item.eatHereOrTakeHome == cartItemEntity.eatHereOrTakeHome &&
          item.totalPrice == cartItemEntity.totalPrice &&
          item.vendorId == vendorEntity.uid) {
        found = true;
        currentCartItemEntity[i] = item.copyWith(quantity: (item.quantity ?? 1) + 1);
        break;
      }
    }

    if (!found && currentVendorEntities.contains(vendorEntity)) {
      currentCartItemEntity.add(cartItemEntity);
    }

    emit(state.copyWith(
      cartItems: currentCartItemEntity,
      vendorEntities: currentVendorEntities,
    ));
  }

  void removeItemFromCart({
    required VendorEntity vendorEntity,
    required CartItemEntity cartItemEntity,
  }) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    final currentCartItemEntity = List<CartItemEntity>.from(state.cartItems);

    currentCartItemEntity.removeWhere((element) => element == cartItemEntity);

    if (!(currentCartItemEntity.contains(cartItemEntity)) &&
        currentCartItemEntity.where((element) => element.vendorId == vendorEntity.uid).isEmpty) {
      currentVendorEntities.remove(vendorEntity);
    }

    emit(state.copyWith(cartItems: currentCartItemEntity, vendorEntities: currentVendorEntities));
  }

  void updateItemInCart({
    required CartItemEntity previousCartItem,
    required CartItemEntity updatedItem,
  }) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element == previousCartItem);
    updatedCartItemEntity[index] = updatedItem;
    log("${updatedCartItemEntity[index].basePrice}");
    updatedCartItemEntity[index] = updatedCartItemEntity[index]
        .copyWith(totalPrice: (updatedCartItemEntity[index].basePrice ?? 0) * updatedItem.quantity!);

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }

  void addAdditionalItemsInCart(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);

    for (int i = 0; i < updatedCartItemEntity.length; i++) {
      CartItemEntity item = updatedCartItemEntity[i];
      if (item.cartId == cartItemEntity.cartId &&
          item.basePrice == cartItemEntity.basePrice &&
          item.dishesEntity == cartItemEntity.dishesEntity &&
          item.eatHereOrTakeHome == cartItemEntity.eatHereOrTakeHome &&
          item.totalPrice == cartItemEntity.totalPrice &&
          item.vendorId == cartItemEntity.vendorId) {
        updatedCartItemEntity[i] = item.copyWith(additional: cartItemEntity.additional);
        break;
      }
    }
    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }

  onTappedQuantityIncreasing(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element == cartItemEntity);
    updatedCartItemEntity[index] =
        updatedCartItemEntity[index].copyWith(quantity: (updatedCartItemEntity[index].quantity ?? 1) + 1);

    // Calculate new price
    updatedCartItemEntity[index] = updatedCartItemEntity[index]
        .copyWith(totalPrice: (updatedCartItemEntity[index].basePrice ?? 0) * (updatedCartItemEntity[index].quantity ?? 1));

    log("${updatedCartItemEntity[index].totalPrice}");
    log("${updatedCartItemEntity[index].quantity}");

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }

  onTappedQuantityDecreasing(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element == cartItemEntity);
    updatedCartItemEntity[index] =
        updatedCartItemEntity[index].copyWith(quantity: (updatedCartItemEntity[index].quantity ?? 1) - 1);

    // Calculate new price
    updatedCartItemEntity[index] = updatedCartItemEntity[index]
        .copyWith(totalPrice: (updatedCartItemEntity[index].basePrice ?? 0) * (updatedCartItemEntity[index].quantity ?? 1));

    log("${updatedCartItemEntity[index].totalPrice}");
    log("${updatedCartItemEntity[index].quantity}");

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }
}
