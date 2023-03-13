import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class FilterOptionEntity extends Equatable {
  final String? filterId;
  final bool? isRequired;
  final bool? isMultiple;
  final List<AddOnsEntity>? addOns;

  const FilterOptionEntity({
    this.filterId,
    this.isRequired,
    this.isMultiple,
    this.addOns,
  });

  @override
  List<Object?> get props => [
        filterId,
        isRequired,
        isMultiple,
        addOns,
      ];
}
