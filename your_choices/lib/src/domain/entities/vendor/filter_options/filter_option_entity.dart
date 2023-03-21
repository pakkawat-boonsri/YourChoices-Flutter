// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class FilterOptionEntity extends Equatable {
  final String? filterId;
  final String? filterName;
  final bool? isRequired;
  final bool? isMultiple;
  final List<AddOnsEntity>? addOns;

  const FilterOptionEntity({
    this.filterId,
    this.filterName,
    this.isRequired,
    this.isMultiple,
    this.addOns,
  });

  @override
  List<Object?> get props => [
        filterId,
        filterName,
        isRequired,
        isMultiple,
        addOns,
      ];

  FilterOptionEntity copyWith({
    String? filterId,
    String? filterName,
    bool? isRequired,
    bool? isMultiple,
    List<AddOnsEntity>? addOns,
  }) {
    return FilterOptionEntity(
      filterId: filterId ?? this.filterId,
      filterName: filterName ?? this.filterName,
      isRequired: isRequired ?? this.isRequired,
      isMultiple: isMultiple ?? this.isMultiple,
      addOns: addOns ?? this.addOns,
    );
  }
}
