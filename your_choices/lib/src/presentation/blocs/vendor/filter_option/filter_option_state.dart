// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../domain/entities/vendor/add_ons/add_ons_entity.dart';

abstract class FilterOptionState extends Equatable {
  const FilterOptionState();
}

class FilterOptionInitial extends FilterOptionState {
  const FilterOptionInitial();

  @override
  List<Object?> get props => [];
}

class FilterOptionLoading extends FilterOptionState {
  const FilterOptionLoading();

  @override
  List<Object?> get props => [];
}

class FilterOptionLoadCompleted extends FilterOptionState {
  final List<FilterOptionEntity> filterOptionEntityList;

  const FilterOptionLoadCompleted({
    required this.filterOptionEntityList,
  });

  @override
  List<Object?> get props => [filterOptionEntityList];
}

class FilterOptionFailure extends FilterOptionState {
  @override
  List<Object?> get props => [];
}

class FilterOptionAddAddOns extends FilterOptionState {
  final List<AddOnsEntity> addOnsEntity;
  const FilterOptionAddAddOns(
    this.addOnsEntity,
  );

  @override
  List<Object?> get props => [addOnsEntity];
}
