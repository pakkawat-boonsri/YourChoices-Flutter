import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

part 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit() : super(FoodDetailInitial());

  List<Map> isChecked = [];

  createListofMapping(List<AddOns>? addons, int index) {
    isChecked = List<Map>.filled(
      addons?.length ?? 0,
      {
        "name": addons?[index].addonsType ?? "",
        "isChecked": true,
      },
    );
  }
}
