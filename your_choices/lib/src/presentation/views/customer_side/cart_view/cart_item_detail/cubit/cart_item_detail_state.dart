// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_item_detail_cubit.dart';

class CartItemDetailState extends Equatable {
  final CartItemEntity? perviousCartItem;
  final List<FilterOptionEntity> filters;
  final List<bool> isSelectRequireFilters;
  final bool isEnable;
  final List<num> additionalPrice;
  final String eatHereOrTakeHome;
  final int quantity;

  const CartItemDetailState({
    this.isEnable = true,
    this.perviousCartItem,
    this.filters = const [],
    this.isSelectRequireFilters = const [],
    this.additionalPrice = const [],
    this.eatHereOrTakeHome = "",
    this.quantity = 1,
  });

  CartItemDetailState copyWith({
    CartItemEntity? perviousCartItem,
    List<FilterOptionEntity>? filters,
    List<bool>? isSelectRequireFilters,
    bool? isEnable,
    List<num>? additionalPrice,
    String? eatHereOrTakeHome,
    int? quantity,
  }) {
    return CartItemDetailState(
      perviousCartItem: perviousCartItem ?? this.perviousCartItem,
      filters: filters ?? this.filters,
      isSelectRequireFilters: isSelectRequireFilters ?? this.isSelectRequireFilters,
      isEnable: isEnable ?? this.isEnable,
      additionalPrice: additionalPrice ?? this.additionalPrice,
      eatHereOrTakeHome: eatHereOrTakeHome ?? this.eatHereOrTakeHome,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        perviousCartItem,
        filters,
        isSelectRequireFilters,
        additionalPrice,
        eatHereOrTakeHome,
        quantity,
        isEnable,
      ];
}
