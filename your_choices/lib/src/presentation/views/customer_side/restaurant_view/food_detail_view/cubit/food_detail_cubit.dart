import 'dart:developer';

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
        isSelectRequireFilters: List.generate(
          dishesEntity.filterOption!.length + 1,
          (index) {
            if (index < dishesEntity.filterOption!.length) {
              final element = dishesEntity.filterOption![index];
              return element.isRequired == false && element.isMultiple == true;
            } else {
              return false;
            }
          },
        ),
        additionalPrice: List.filled(
          dishesEntity.filterOption!.length,
          0,
        ),
      ),
    );
    log("${state.isSelectRequireFilters}");
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

    updatedFilters[index] = filter.copyWith(selectedAddOnRadioListTile: value);

    if (updatedFilters[index].selectedAddOnRadioListTile != null) {
      updatedIsSelectRequireFilters[index] = true;
    } else {
      updatedIsSelectRequireFilters[index] = false;
    }

    log("$updatedIsSelectRequireFilters");

    if (updatedFilters[index].selectedAddOnRadioListTile != null &&
        updatedIsSelectRequireFilters[index] == true &&
        updatedFilters[index].selectedAddOnRadioListTile == value) {
      if (updatedFilters[index].selectedAddOnRadioListTile!.priceType == RadioTypes.nochange.toString()) {
        updatedAdditionalPrice[index] = 0;
      } else if (updatedFilters[index].selectedAddOnRadioListTile!.priceType == RadioTypes.priceIncrease.toString()) {
        updatedAdditionalPrice[index] = updatedFilters[index].selectedAddOnRadioListTile!.price!;
      } else if (updatedFilters[index].selectedAddOnRadioListTile!.priceType == RadioTypes.priceDecrease.toString()) {
        updatedAdditionalPrice[index] = -updatedFilters[index].selectedAddOnRadioListTile!.price!;
      }
    }
    emit(state.copyWith(
      filters: updatedFilters,
      isSelectRequireFilters: updatedIsSelectRequireFilters,
      additionalPrice: updatedAdditionalPrice,
    ));
  }

  void onTappedCheckboxListTile(int index, AddOnsEntity addOn) {
    final currentState = state;
    final updatedFilters = List<FilterOptionEntity>.from(currentState.filters);
    final updatedAdditionalPrice = List<num>.from(state.additionalPrice);

    final updatedAddOns = List<AddOnsEntity>.from(updatedFilters[index].addOns!);
    final addOnIndex = updatedAddOns.indexOf(addOn);

    updatedAddOns[addOnIndex] = addOn.copyWith(isSelected: !addOn.isSelected);
    final maximumSelectedAddOns = updatedFilters[index].multipleQuantity;

    // Check if the maximum number of add-ons has been selected
    final selectedAddOns = updatedAddOns.where((element) => element.isSelected).toList();
    final isMaximumSelected = selectedAddOns.length == maximumSelectedAddOns;

    if (isMaximumSelected) {
      emit(state.copyWith(isEnable: false));
    } else {
      emit(state.copyWith(isEnable: true));
    }

    final selectedCheckBoxAddOns = selectedAddOns.toList();

    if (updatedAddOns[addOnIndex].isSelected) {
      if (addOn.priceType == "RadioTypes.priceIncrease") {
        updatedAdditionalPrice[index] += addOn.price ?? 0;
      } else if (addOn.priceType == "RadioTypes.priceDecrease") {
        updatedAdditionalPrice[index] -= addOn.price ?? 0;
      }
    } else {
      if (addOn.priceType == "RadioTypes.priceIncrease") {
        updatedAdditionalPrice[index] -= addOn.price ?? 0;
      } else if (addOn.priceType == "RadioTypes.priceDecrease") {
        updatedAdditionalPrice[index] += addOn.price ?? 0;
      }
    }

    updatedFilters[index] = updatedFilters[index].copyWith(
      selectedAddOnCheckBoxListTile: selectedCheckBoxAddOns,
    );

    log("${updatedFilters[index].selectedAddOnCheckBoxListTile}");
    log("$updatedAdditionalPrice");

    updatedFilters[index] = updatedFilters[index].copyWith(addOns: updatedAddOns);

    emit(
      state.copyWith(
        filters: updatedFilters,
        additionalPrice: updatedAdditionalPrice,
      ),
    );
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
