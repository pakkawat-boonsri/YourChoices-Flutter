// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class FilterOptionEntity extends Equatable {
  final String? filterId;
  final String? filterName;
  final bool? isRequired;
  final bool? isMultiple;
  final int? multipleQuantity;
  final List<AddOnsEntity>? addOns;

  //not store in db
  final bool isSelected;
  const FilterOptionEntity({
    this.filterId,
    this.filterName,
    this.isRequired,
    this.isMultiple,
    this.multipleQuantity,
    this.isSelected = false,
    this.addOns,
  });

  @override
  List<Object?> get props => [
        filterId,
        filterName,
        isRequired,
        isMultiple,
        isSelected,
        addOns,
        multipleQuantity,
      ];

  FilterOptionEntity copyWith({
    String? filterId,
    String? filterName,
    bool? isRequired,
    bool? isMultiple,
    bool? isSelected,
    int? multipleQuantity,
    List<AddOnsEntity>? addOns,
  }) {
    return FilterOptionEntity(
      filterId: filterId ?? this.filterId,
      filterName: filterName ?? this.filterName,
      isRequired: isRequired ?? this.isRequired,
      isMultiple: isMultiple ?? this.isMultiple,
      isSelected: isSelected ?? this.isSelected,
      multipleQuantity: multipleQuantity ?? this.multipleQuantity,
      addOns: addOns ?? this.addOns,
    );
  }
}
