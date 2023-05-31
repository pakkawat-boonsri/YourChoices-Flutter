import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

class FilterOptionModel extends FilterOptionEntity {
  const FilterOptionModel({
    final String? filterId,
    final String? filterName,
    final bool? isRequired,
    final bool? isMultiple,
    final bool isSelected = false,
    final int? multipleQuantity,
    final List<AddOnsEntity>? addOns,
  }) : super(
          filterId: filterId,
          isRequired: isRequired,
          isMultiple: isMultiple,
          multipleQuantity: multipleQuantity,
          addOns: addOns,
          isSelected: isSelected,
          filterName: filterName,
        );

  factory FilterOptionModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FilterOptionModel(
      filterId: snapshot['filterId'],
      filterName: snapshot['filterName'],
      isRequired: snapshot['isRequired'],
      isMultiple: snapshot['isMultiple'],
      multipleQuantity: snapshot['multipleQuantity'],
      addOns: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        "filterId": filterId,
        "isRequired": isRequired,
        "isMultiple": isMultiple,
        "filterName": filterName,
        "multipleQuantity": multipleQuantity,
      };
}
