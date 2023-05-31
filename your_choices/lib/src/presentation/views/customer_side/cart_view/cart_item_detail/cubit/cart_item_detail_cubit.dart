import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

part 'cart_item_detail_state.dart';

class CartItemDetailCubit extends Cubit<CartItemDetailState> {
  CartItemDetailCubit() : super(const CartItemDetailState());

  init(CartItemEntity cartItemEntity) {
    final filters = cartItemEntity.dishesEntity!.filterOption?.map((filter) {
      return FilterOptionEntity(
        filterId: filter.filterId,
        filterName: filter.filterName,
        isMultiple: filter.isMultiple,
        isRequired: filter.isRequired,
        multipleQuantity: filter.multipleQuantity,
        addOns: filter.addOns,
        selectedAddOnRadioListTile: filter.selectedAddOnRadioListTile,
        selectedAddOnCheckBoxListTile: filter.selectedAddOnCheckBoxListTile,
      );
    }).toList();

    final additionalPrice = cartItemEntity.dishesEntity!.filterOption?.map((filterOption) {
      final addOnRadioListTile = filterOption.selectedAddOnRadioListTile;
      final addOnCheckBoxListTile = filterOption.selectedAddOnCheckBoxListTile;

      if (addOnRadioListTile != null || (addOnCheckBoxListTile != null && addOnCheckBoxListTile.isNotEmpty)) {
        final priceType = addOnRadioListTile?.priceType;
        final price = addOnRadioListTile?.price;

        if (priceType == RadioTypes.nochange.toString()) {
          return 0;
        } else if (priceType == RadioTypes.priceIncrease.toString()) {
          return price ?? 0;
        } else if (priceType == RadioTypes.priceDecrease.toString()) {
          return -(price ?? 0);
        } else {
          for (AddOnsEntity addOnInSeletedCheckbox in addOnCheckBoxListTile!) {
            if (addOnInSeletedCheckbox.priceType == RadioTypes.nochange.toString()) {
              return 0;
            } else if (addOnInSeletedCheckbox.priceType == RadioTypes.priceIncrease.toString()) {
              return addOnInSeletedCheckbox.price!;
            } else if (addOnInSeletedCheckbox.priceType == RadioTypes.priceDecrease.toString()) {
              return -(addOnInSeletedCheckbox.price!);
            }
          }
        }
      }
      return 0; // Set a default value for elements that don't satisfy the conditions
    }).toList();

    final isEatHereOrTakeHomeChecked = cartItemEntity.eatHereOrTakeHome != null;

    final isSelectRequireFilters = List.generate(
      cartItemEntity.dishesEntity!.filterOption!.length + 1,
      (index) {
        if (cartItemEntity.dishesEntity!.filterOption!.isEmpty) {
          return isEatHereOrTakeHomeChecked ? true : false;
        } else {
          if (index < cartItemEntity.dishesEntity!.filterOption!.length) {
            final filterOption = cartItemEntity.dishesEntity!.filterOption![index];
            final isAddOnRadioListTileSelected = filterOption.selectedAddOnRadioListTile != null;
            final isAddOnCheckBoxListTileSeleted = filterOption.selectedAddOnCheckBoxListTile;
            final alwaysTrue = isAddOnCheckBoxListTileSeleted != null ||
                    (isAddOnCheckBoxListTileSeleted?.isNotEmpty ?? false) ||
                    isAddOnCheckBoxListTileSeleted == null ||
                    (isAddOnCheckBoxListTileSeleted.isEmpty)
                ? true
                : false;
            return isAddOnRadioListTileSelected || alwaysTrue;
          } else {
            return isEatHereOrTakeHomeChecked ? true : false;
          }
        }
      },
    );

    final isEanble = cartItemEntity.dishesEntity?.filterOption?.where((element) {
          return element.isMultiple == true && element.selectedAddOnCheckBoxListTile?.length == element.multipleQuantity;
        }).isEmpty ??
        true;

    emit(
      state.copyWith(
        perviousCartItem: cartItemEntity,
        quantity: cartItemEntity.quantity,
        eatHereOrTakeHome: cartItemEntity.eatHereOrTakeHome,
        filters: filters,
        isEnable: isEanble,
        isSelectRequireFilters: isSelectRequireFilters,
        additionalPrice: additionalPrice,
      ),
    );

    log("${state.isSelectRequireFilters}");
    log("${state.additionalPrice}");
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
    log("$updatedAdditionalPrice");
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
