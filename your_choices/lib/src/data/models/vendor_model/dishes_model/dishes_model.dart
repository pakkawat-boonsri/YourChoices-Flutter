import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

import '../add_ons_model/add_ons_model.dart';

class DishesModel extends DishesEntity {
  const DishesModel({
    final String? dishesId,
    final String? menuName,
    final String? menuImg,
    final num? menuPrice,
    final String? menuDescription,
    final List<AddOnsModel>? addOns,
  }) : super(
          dishesId: dishesId,
          addOns: addOns,
          menuDescription: menuDescription,
          menuImg: menuImg,
          menuName: menuName,
          menuPrice: menuPrice,
        );

  factory DishesModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return DishesModel(
      addOns: List.from(
        snapshot['add_ons'].map(
          (x) => AddOnsModel.fromFirebase(snap),
        ),
      ),
      menuDescription: snapshot['menuDescription'],
      menuImg: snapshot['menuImg'],
      menuName: snapshot['menuName'],
      menuPrice: snapshot['menuPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addOns'] = addOns;
    data['menuDescription'] = menuDescription;
    data['menuImg'] = menuImg;
    data['menuName'] = menuName;
    data['menuPrice'] = menuPrice;
    return data;
  }
}
