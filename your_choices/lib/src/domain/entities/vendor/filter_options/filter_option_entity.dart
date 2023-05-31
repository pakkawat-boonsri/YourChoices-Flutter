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
  final AddOnsEntity? selectedAddOnRadioListTile;
  final List<AddOnsEntity>? selectedAddOnCheckBoxListTile;

  //not store in db
  final bool isSelected;
  final bool isExpanded;
  const FilterOptionEntity({
    this.filterId,
    this.filterName,
    this.isRequired,
    this.isMultiple,
    this.multipleQuantity,
    this.addOns,
    this.selectedAddOnRadioListTile,
    this.selectedAddOnCheckBoxListTile,
    this.isSelected = false,
    this.isExpanded = true,
  });

  @override
  List<Object?> get props => [
        filterId,
        filterName,
        isRequired,
        isMultiple,
        multipleQuantity,
        addOns,
        selectedAddOnRadioListTile,
        selectedAddOnCheckBoxListTile,
        isSelected,
        isExpanded,
      ];

  FilterOptionEntity copyWith({
    String? filterId,
    String? filterName,
    bool? isRequired,
    bool? isMultiple,
    int? multipleQuantity,
    List<AddOnsEntity>? addOns,
    AddOnsEntity? selectedAddOnRadioListTile,
    List<AddOnsEntity>? selectedAddOnCheckBoxListTile,
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
      selectedAddOnRadioListTile: selectedAddOnRadioListTile ?? this.selectedAddOnRadioListTile,
      selectedAddOnCheckBoxListTile: selectedAddOnCheckBoxListTile ?? this.selectedAddOnCheckBoxListTile,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filterId': filterId,
      'filterName': filterName,
      'isRequired': isRequired,
      'isMultiple': isMultiple,
      'multipleQuantity': multipleQuantity,
      // 'addOns': addOns?.map((x) => x.toMap()).toList(),
      'selectedAddOnRadioListTile': selectedAddOnRadioListTile?.toMap(),
      'selectedAddOnCheckBoxListTile': selectedAddOnCheckBoxListTile?.map((x) => x.toMap()).toList(),
    };
  }

  factory FilterOptionEntity.fromMap(Map<String, dynamic> map) {
    return FilterOptionEntity(
      filterId: map['filterId'] != null ? map['filterId'] as String : null,
      filterName: map['filterName'] != null ? map['filterName'] as String : null,
      isRequired: map['isRequired'] != null ? map['isRequired'] as bool : null,
      isMultiple: map['isMultiple'] != null ? map['isMultiple'] as bool : null,
      multipleQuantity: map['multipleQuantity'] != null ? map['multipleQuantity'] as int : null,
      addOns: map['addOns'] != null
          ? List<AddOnsEntity>.from(
              (map['addOns'] as List<int>).map<AddOnsEntity?>(
                (x) => AddOnsEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      selectedAddOnRadioListTile: map['selectedAddOnRadioListTile'] != null
          ? AddOnsEntity.fromMap(map['selectedAddOnRadioListTile'] as Map<String, dynamic>)
          : null,
      selectedAddOnCheckBoxListTile: map['selectedAddOnCheckBoxListTile'] != null
          ? List<AddOnsEntity>.from(
              (map['selectedAddOnCheckBoxListTile'] as List<dynamic>).map<AddOnsEntity?>(
                (x) => AddOnsEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
