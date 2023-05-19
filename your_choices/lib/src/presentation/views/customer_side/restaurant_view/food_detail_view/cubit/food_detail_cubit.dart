import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

part 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit() : super(const FoodDetailState());

  init(DishesEntity dishesEntity) {
    emit(
      state.copyWith(
        filters: List.generate(
          dishesEntity.filterOption!.length,
          (index) => FilterOptionEntity(
            filterId: dishesEntity.filterOption?[index].filterId,
            filterName: dishesEntity.filterOption?[index].filterName,
            isMultiple: dishesEntity.filterOption?[index].isMultiple,
            isRequired: dishesEntity.filterOption?[index].isRequired,
            multipleQuantity: dishesEntity.filterOption?[index].multipleQuantity,
            addOns: dishesEntity.filterOption?[index].addOns,
          ),
        ),
        isSelectRequireFilters: List.filled(
          dishesEntity.filterOption!.where((element) => element.isRequired == true).length + 1,
          false,
        ),
        additionalPrice: List.filled(
          dishesEntity.filterOption!.length,
          0,
        ),
      ),
    );
  }

  void onExpansionPanelTapped(int panelIndex, bool isExpanded) {
    final currentState = state;
    final updatedFilters = List<FilterOptionEntity>.from(currentState.filters);
    updatedFilters[panelIndex] = updatedFilters[panelIndex].copyWith(isExpanded: !isExpanded);
    emit(state.copyWith(filters: updatedFilters));
  }

  void onTappedRadioListTile(
    int index,
    FilterOptionEntity filter,
    AddOnsEntity? value,
  ) {
    final currentState = state;
    final updatedFilters = List<FilterOptionEntity>.from(currentState.filters);
    final updatedIsSelectRequireFilters = List<bool>.from(currentState.isSelectRequireFilters);

    final updatedAdditionalPrice = List<num>.from(state.additionalPrice);

    updatedFilters[index] = filter.copyWith(selectedAddOns: value);

    if (updatedFilters[index].selectedAddOns != null) {
      updatedIsSelectRequireFilters[index] = true;
    } else {
      updatedIsSelectRequireFilters[index] = false;
    }

    if (updatedFilters[index].selectedAddOns != null &&
        updatedIsSelectRequireFilters[index] == true &&
        updatedFilters[index].selectedAddOns == value) {
      if (updatedFilters[index].selectedAddOns!.priceType == RadioTypes.nochange.toString()) {
        updatedAdditionalPrice[index] = 0;
      } else if (updatedFilters[index].selectedAddOns!.priceType == RadioTypes.priceIncrease.toString()) {
        updatedAdditionalPrice[index] = updatedFilters[index].selectedAddOns!.price!;
      } else if (updatedFilters[index].selectedAddOns!.priceType == RadioTypes.priceDecrease.toString()) {
        updatedAdditionalPrice[index] = -updatedFilters[index].selectedAddOns!.price!;
      }
    }
    emit(state.copyWith(
      filters: updatedFilters,
      isSelectRequireFilters: updatedIsSelectRequireFilters,
      additionalPrice: updatedAdditionalPrice,
    ));
  }

  onTappedEatHereOrTakeHome(String? value) {
    final updatedIsSelectRequireFilters = List<bool>.from(state.isSelectRequireFilters);
    if (state.eatHereOrTakeHome != null) {
      updatedIsSelectRequireFilters.last = true;
    } else {
      updatedIsSelectRequireFilters.last = false;
    }
    emit(
      state.copyWith(
        eatHereOrTakeHome: value,
        isSelectRequireFilters: updatedIsSelectRequireFilters,
      ),
    );
  }

  onTappedQuantityIncreasing() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  onTappedQuantityDecreasing() {
    emit(state.copyWith(quantity: state.quantity - 1));
  }
}
