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
  final AddOnsEntity? selectedAddOns;
  final bool isSelected; //use for vendor to selected to add to menu
  final bool isExpanded; //use for expansionpanel
  const FilterOptionEntity({
    this.filterId,
    this.filterName,
    this.isRequired,
    this.isMultiple,
    this.multipleQuantity,
    this.addOns,
    this.selectedAddOns,
    this.isSelected = false,
    this.isExpanded = true,
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
        isExpanded,
        selectedAddOns,
      ];

  FilterOptionEntity copyWith({
    String? filterId,
    String? filterName,
    bool? isRequired,
    bool? isMultiple,
    int? multipleQuantity,
    List<AddOnsEntity>? addOns,
    AddOnsEntity? selectedAddOns,
    bool? isSelected,
    bool? isExpanded,
  }) {
    return FilterOptionEntity(
      filterId: filterId ?? this.filterId,
      filterName: filterName ?? this.filterName,
      isRequired: isRequired ?? this.isRequired,
      isMultiple: isMultiple ?? this.isMultiple,
      multipleQuantity: multipleQuantity ?? this.multipleQuantity,
      addOns: addOns ?? this.addOns,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
