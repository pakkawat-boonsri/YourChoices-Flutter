import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class AddOnsModel extends AddOnsEntity {
  const AddOnsModel({
    final String? addonsId,
    final String? addonsName,
    final String? priceType,
    final num? price,
  }) : super(
          addonsName: addonsName,
          price: price,
          addonsId: addonsId,
          priceType: priceType,
        );

  factory AddOnsModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddOnsModel(
      addonsName: snapshot['addonsName'],
      price: snapshot['price'],
      addonsId: snapshot['addonsId'],
      priceType: snapshot['priceType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsName'] = addonsName;
    data['price'] = price;
    data['addonsId'] = addonsId;
    data['priceType'] = priceType;
    return data;
  }

}
