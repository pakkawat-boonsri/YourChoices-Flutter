import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/data/models/vendor_model/filter_option_model/filter_option_model.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

class DishesModel extends DishesEntity {
  const DishesModel({
    final String? dishesId,
    final Timestamp? createdAt,
    final bool? isActive,
    final String? menuName,
    final String? menuImg,
    final num? menuPrice,
    final String? menuDescription,
    final List<FilterOptionEntity>? filterOption,
  }) : super(
          isActive: isActive,
          dishesId: dishesId,
          filterOption: filterOption,
          menuDescription: menuDescription,
          menuImg: menuImg,
          menuName: menuName,
          menuPrice: menuPrice,
          createdAt: createdAt,
        );

  factory DishesModel.fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return DishesModel(
      createdAt: snapshot['createdAt'],
      dishesId: snapshot['dishesId'],
      filterOption: (snapshot['filterOption'] as List)
          .map((e) => FilterOptionModel.fromFirebase(e))
          .toList(),
      menuDescription: snapshot['menuDescription'],
      menuImg: snapshot['menuImg'],
      menuName: snapshot['menuName'],
      menuPrice: snapshot['menuPrice'],
      isActive: snapshot['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "dishesId": dishesId,
        "filterOption": filterOption,
        "menuDescription": menuDescription,
        "menuImg": menuImg,
        "menuName": menuName,
        "menuPrice": menuPrice,
        "createdAt": createdAt,
      };
}
