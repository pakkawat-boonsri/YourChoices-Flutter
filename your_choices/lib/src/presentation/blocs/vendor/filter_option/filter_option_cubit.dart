import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/vendor/add_ons/add_ons_entity.dart';

part 'filter_option_state.dart';

class FilterOptionCubit extends Cubit<FilterOptionState> {
  FilterOptionCubit() : super(FilterOptionInitial());

  final List<AddOnsEntity> addOnsList = <AddOnsEntity>[];

  List<AddOnsEntity> get getAddOnsList => addOnsList;

  Future<void> addAddOns(
    AddOnsEntity addOnsEntity,
  ) async {
    addOnsList.add(addOnsEntity);

    emit(FilterOptionAddAddOns(addOnsList));
  }

  Future<void> removeAddOns(
    AddOnsEntity addOnsEntity,
  ) async {
    addOnsList.removeWhere(
      (element) => element.addonsId == addOnsEntity.addonsId,
    );
    emit(FilterOptionAddAddOns(addOnsList));
  }

  Future<void> resetAddOnsList() async {
    addOnsList.clear();
  }
}
