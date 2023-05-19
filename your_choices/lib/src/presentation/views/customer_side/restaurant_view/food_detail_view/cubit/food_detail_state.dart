// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'food_detail_cubit.dart';

class FoodDetailState extends Equatable {
  final List<FilterOptionEntity> filters;
  final List<bool> isSelectRequireFilters;
  final List<num> additionalPrice;
  final String eatHereOrTakeHome;
  final int quantity;

  const FoodDetailState({
    this.filters = const [],
    this.isSelectRequireFilters = const [],
    this.additionalPrice = const [],
    this.eatHereOrTakeHome = "",
    this.quantity = 1,
  });

  @override
  List<Object> get props => [
        filters,
        isSelectRequireFilters,
        additionalPrice,
        eatHereOrTakeHome,
        quantity,
      ];

  FoodDetailState copyWith({
    List<FilterOptionEntity>? filters,
    List<bool>? isSelectRequireFilters,
    List<num>? additionalPrice,
    String? eatHereOrTakeHome,
    int? quantity,
  }) {
    return FoodDetailState(
      filters: filters ?? this.filters,
      isSelectRequireFilters:
          isSelectRequireFilters ?? this.isSelectRequireFilters,
      additionalPrice: additionalPrice ?? this.additionalPrice,
      eatHereOrTakeHome: eatHereOrTakeHome ?? this.eatHereOrTakeHome,
      quantity: quantity ?? this.quantity,
    );
  }
}
