import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../domain/entities/vendor/add_ons/add_ons_entity.dart';

class FilterOptionModel extends FilterOptionEntity {
  const FilterOptionModel({
    final String? filterId,
    final String? filterName,
    final bool? isRequired,
    final bool? isMultiple,
    final List<AddOnsEntity>? addOns,
  }) : super(
            filterId: filterId,
            isRequired: isRequired,
            isMultiple: isMultiple,
            addOns: addOns,
            filterName: filterName);

  factory FilterOptionModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FilterOptionModel(
      filterId: snapshot['filterId'],
      filterName: snapshot['filterName'],
      isRequired: snapshot['isRequired'],
      isMultiple: snapshot['isMultiple'],
      addOns: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        "filterId": filterId,
        "isRequired": isRequired,
        "isMultiple": isMultiple,
        "filterName": filterName,
      };

  @override
  FilterOptionModel copyWith({
    final String? filterId,
    final String? filterName,
    final bool? isRequired,
    final bool? isMultiple,
    final List<AddOnsEntity>? addOns,
  }) {
    return FilterOptionModel(
      filterId: filterId ?? this.filterId,
      filterName: filterName ?? this.filterName,
      isMultiple: isMultiple ?? this.isMultiple,
      isRequired: isRequired ?? this.isRequired,
      addOns: addOns ?? this.addOns,
    );
  }
}
