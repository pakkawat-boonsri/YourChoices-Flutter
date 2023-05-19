import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/data/models/vendor_model/dishes_model/dishes_model.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    final String? uid,
    final String? email,
    final String? username,
    final String? type,
    final String? profileUrl,
    final String? resName,
    final String? resProfileUrl,
    final bool? isActive,
    final num? onQueue,
    final String? description,
    final num? totalPriceSell,
    final String? restaurantType,
    final List<DishesEntity>? dishes,
  }) : super(
          uid: uid,
          resName: resName,
          resProfileUrl: resProfileUrl,
          isActive: isActive,
          onQueue: onQueue,
          description: description,
          totalPriceSell: totalPriceSell,
          dishes: dishes,
          email: email,
          username: username,
          profileUrl: profileUrl,
          type: type,
          restaurantType: restaurantType,
        );

  factory VendorModel.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VendorModel(
      username: snapshot['username'],
      description: snapshot['description'],
      dishes: List.from(
        snapshot['dishes'].map(
          (x) => DishesModel.fromFirebase(snap),
        ),
      ),
      isActive: snapshot['isActive'],
      onQueue: snapshot['onQueue'],
      resName: snapshot['resName'],
      resProfileUrl: snapshot['resProfileUrl'],
      totalPriceSell: snapshot['totalPriceSell'],
      profileUrl: snapshot['profileUrl'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      type: snapshot['type'],
      restaurantType: snapshot['restaurantType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    data['uid'] = uid;
    data['description'] = description;
    data['dishes'] = dishes;
    data['isActive'] = isActive;
    data['onQueue'] = onQueue;
    data['resName'] = resName;
    data['resProfileUrl'] = resProfileUrl;
    data['totalPriceSell'] = totalPriceSell;
    data['type'] = type;
    data['restaurantType'] = restaurantType;
    return data;
  }
}
