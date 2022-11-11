class RestaurantModel {
  String? resName;
  String? description;
  String? resImg;
  int? onQueue;
  int? totalPriceSell;
  bool? isAction;
  List<Foods>? foods;

  RestaurantModel(
      {this.resName,
      this.description,
      this.resImg,
      this.onQueue,
      this.totalPriceSell,
      this.isAction,
      this.foods});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    resName = json['resName'];
    description = json['description'];
    resImg = json['resImg'];
    onQueue = json['onQueue'];
    totalPriceSell = json['totalPriceSell'];
    isAction = json['isAction'];
    if (json['foods'] != null) {
      foods = <Foods>[];
      json['foods'].forEach((v) {
        foods!.add(Foods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resName'] = resName;
    data['description'] = description;
    data['resImg'] = resImg;
    data['onQueue'] = onQueue;
    data['totalPriceSell'] = totalPriceSell;
    data['isAction'] = isAction;
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  String? menuName;
  String? menuImg;
  int? menuPrice;
  List<AddOns>? addOns;

  Foods({this.menuName, this.menuImg, this.menuPrice, this.addOns});

  Foods.fromJson(Map<String, dynamic> json) {
    menuName = json['menuName'];
    menuImg = json['menuImg'];
    menuPrice = json['menuPrice'];
    if (json['add_ons'] != null) {
      addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuName'] = menuName;
    data['menuImg'] = menuImg;
    data['menuPrice'] = menuPrice;
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddOns {
  String? addonsType;
  int? price;

  AddOns({this.addonsType, this.price});

  AddOns.fromJson(Map<String, dynamic> json) {
    addonsType = json['addonsType'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsType'] = addonsType;
    data['price'] = price;
    return data;
  }
}
