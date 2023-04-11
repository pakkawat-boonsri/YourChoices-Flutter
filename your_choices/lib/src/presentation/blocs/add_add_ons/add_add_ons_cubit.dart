import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class AddAddOnsCubit extends Cubit<List<AddOnsEntity>> {
  AddAddOnsCubit() : super([]);

  addAddOns(AddOnsEntity addOnsEntity) {
    final List<AddOnsEntity> addOnsList = [...state];

    addOnsList.add(addOnsEntity);
    emit(addOnsList);
  }

  removeAddOns(int index) {
    final List<AddOnsEntity> addOnsList = [...state];
    addOnsList.removeAt(index);
    emit(addOnsList);
  }

  resetAddOns() {
    final List<AddOnsEntity> addOnsList = [];
    emit(addOnsList);
  }
}
