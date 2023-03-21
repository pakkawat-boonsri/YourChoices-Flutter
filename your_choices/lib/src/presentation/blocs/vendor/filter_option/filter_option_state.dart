part of 'filter_option_cubit.dart';

abstract class FilterOptionState extends Equatable {
  const FilterOptionState();
}

class FilterOptionInitial extends FilterOptionState {
  @override
  List<Object?> get props => [];
}

class FilterOptionAddAddOns extends FilterOptionState {
  final List<AddOnsEntity> addOnsEntity;

  const FilterOptionAddAddOns(this.addOnsEntity);

  @override
  List<Object?> get props => [addOnsEntity];
}
