import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class AddOnsModel extends AddOnsEntity {
  const AddOnsModel({
  final String? addonsId,
  final String? addonsType,
  final num? price,
  }) : super(
          addonsType: addonsType,
          price: price,
          addonsId: addonsId,
        );

  factory AddOnsModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddOnsModel(
      addonsType: snapshot['addonsType'],
      price: snapshot['price'],
      addonsId: snapshot['addonsId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsType'] = addonsType;
    data['price'] = price;
    data['addonsId'] = addonsId;
    return data;
  }
}
