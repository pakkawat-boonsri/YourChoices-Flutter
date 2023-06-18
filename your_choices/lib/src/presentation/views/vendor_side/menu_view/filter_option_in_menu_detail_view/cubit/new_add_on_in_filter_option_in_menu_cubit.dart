import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class NewAddOnInFilterOptionInMenuCubit extends Cubit<List<AddOnsEntity>> {
  NewAddOnInFilterOptionInMenuCubit() : super([]);

  init(List<AddOnsEntity> newAddOns) {
    final List<AddOnsEntity> currentState = List.from(state);
    for (var element in newAddOns) {
      if (!currentState.contains(element)) {
        currentState.add(element);
      }
    }
    emit(currentState);
  }

  onResetAddOns() {
    state.clear();
  }

  onAddingAddOnInFilterOptionInMenuDetail(AddOnsEntity addOnsEntity) {
    final List<AddOnsEntity> currentAddOns = List.from(state);
    currentAddOns.add(addOnsEntity);
    log("$currentAddOns");
    emit(currentAddOns);
  }

  onDeleteAddOnInFilterOptionInMenuDetail(AddOnsEntity addOnsEntity) {
    final List<AddOnsEntity> currentAddOns = List.from(state);
    currentAddOns.remove(addOnsEntity);
    emit(currentAddOns);
  }

  final List<AddOnsEntity> deletedAddOns = [];

  resetDeleteAddOns() {
    deletedAddOns.clear();
    log("$deletedAddOns");
  }

  addingDeletedAddOns(AddOnsEntity addOnsEntity) {
    deletedAddOns.add(addOnsEntity);
    log("$deletedAddOns");
  }
}
