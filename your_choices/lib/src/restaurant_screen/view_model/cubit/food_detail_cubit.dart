import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

part 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {

  FoodDetailCubit() : super(FoodDetailInitial());

  List<Map> _isChecked = [];
  
  createListofMapping(List<AddOns>? addons, int index) {
    _isChecked = List<Map>.filled(
      addons?.length ?? 0,
      {
        "name": addons?[index].addonsType ?? "",
        "isChecked": true,
      },
    );
  }
}
