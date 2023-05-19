import 'package:bloc/bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

class AddFilterOptionCubit extends Cubit<List<FilterOptionEntity>> {
  AddFilterOptionCubit() : super([]);

  List<FilterOptionEntity> get filterOptionList => state;

  addFilterOption(FilterOptionEntity filterOptionEntity) {
    final List<FilterOptionEntity> filterOptionList = [...state];

    filterOptionList.add(filterOptionEntity);

    emit(filterOptionList);
  }

  removeFilterOption(FilterOptionEntity filterOptionEntity) {
    final List<FilterOptionEntity> filterOptionList = [...state];
    filterOptionList.removeWhere(
      (element) => element.filterId == filterOptionEntity.filterId,
    );
    emit(filterOptionList);
  }

  resetFilterOption() {
    final List<FilterOptionEntity> filterOptionList = [];
    emit(filterOptionList);
  }
}
