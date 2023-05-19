import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(
          const CartState(
            vendorEntities: [],
            cartItems: [],
          ),
        );

  void addItemToCart({
    required VendorEntity vendorEntity,
    required CartItemEntity cartItemEntity,
  }) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    final currentCartItemEntity = List<CartItemEntity>.from(state.cartItems);

    if (!currentVendorEntities.contains(vendorEntity)) {
      currentVendorEntities.add(vendorEntity);
    }

    if (currentCartItemEntity.contains(cartItemEntity) && currentVendorEntities.contains(cartItemEntity.vendorEntity)) {
      int index = currentCartItemEntity.indexOf(cartItemEntity);
      currentCartItemEntity[index] =
          currentCartItemEntity[index].copyWith(quantity: currentCartItemEntity[index].quantity ?? 1 + 1);
    } else if (!(currentCartItemEntity.contains(cartItemEntity)) &&
        currentVendorEntities.contains(cartItemEntity.vendorEntity)) {
      currentCartItemEntity.add(cartItemEntity);
    }

    emit(state.copyWith(
      cartItems: currentCartItemEntity,
      vendorEntities: currentVendorEntities,
    ));
  }

  void removeItemFromCart({
    required CartItemEntity cartItemEntity,
  }) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    final currentCartItemEntity = List<CartItemEntity>.from(state.cartItems);

    currentCartItemEntity.removeWhere((element) => element == cartItemEntity);

    if (!(currentCartItemEntity.contains(cartItemEntity)) &&
        currentCartItemEntity.where((element) => element.vendorEntity == cartItemEntity.vendorEntity).isEmpty) {
      currentVendorEntities.remove(cartItemEntity.vendorEntity);
    }

    emit(state.copyWith(cartItems: currentCartItemEntity, vendorEntities: currentVendorEntities));
  }

  void addAdditionalItemsInCart(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element.cartId == cartItemEntity.cartId);
    updatedCartItemEntity[index] = updatedCartItemEntity[index].copyWith(additional: cartItemEntity.additional);

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }

  onTappedQuantityIncreasing(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element == cartItemEntity);
    updatedCartItemEntity[index] =
        updatedCartItemEntity[index].copyWith(quantity: (updatedCartItemEntity[index].quantity ?? 1) + 1);

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }

  onTappedQuantityDecreasing(CartItemEntity cartItemEntity) {
    final updatedCartItemEntity = List<CartItemEntity>.from(state.cartItems);
    final index = updatedCartItemEntity.indexWhere((element) => element == cartItemEntity);
    updatedCartItemEntity[index] =
        updatedCartItemEntity[index].copyWith(quantity: (updatedCartItemEntity[index].quantity ?? 1) - 1);

    emit(state.copyWith(cartItems: updatedCartItemEntity));
  }
}
