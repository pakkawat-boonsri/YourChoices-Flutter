import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/data/models/vendor_model/add_ons_model/add_ons_model.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../domain/entities/vendor/add_ons/add_ons_entity.dart';

class FilterOptionModel extends FilterOptionEntity {
  const FilterOptionModel({
    final String? filterId,
    final bool? isRequired,
    final bool? isMultiple,
    final List<AddOnsEntity>? addOns,
  }) : super(
          filterId: filterId,
          isRequired: isRequired,
          isMultiple: isMultiple,
          addOns: addOns,
        );

  factory FilterOptionModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FilterOptionModel(
      filterId: snapshot['filterId'],
      isRequired: snapshot['isRequired'],
      isMultiple: snapshot['isMultiple'],
      addOns: (snapshot['addOns'] as List)
          .map((e) => AddOnsModel.fromFirebase(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "filterId": filterId,
        "isRequired": isRequired,
        "isMultiple": isMultiple,
        "addOns": addOns,
      };
}
