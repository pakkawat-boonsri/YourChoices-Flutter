// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/restaurant_list_view/widgets/list_of_restaurants.dart';
import 'package:your_choices/src/presentation/views/customer_side/search_box_view/bloc/search_box_bloc.dart';
import 'package:your_choices/src/presentation/views/customer_side/search_box_view/seach_box_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class RestaurantListView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const RestaurantListView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> with SingleTickerProviderStateMixin {
  final searchText = TextEditingController();
  late TabController tabController;
  List<String> restaurantTypes = ["ร้านอาหารตามสั่ง", "ร้านข้าวแกง", "ร้านก๋วยเตี๋ยว", "ร้านเครื่องดื่ม"];
  late String selectedType;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: restaurantTypes.length, initialIndex: 0);
    selectedType = restaurantTypes[0];
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurant();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return state.cartItems.isEmpty
              ? Container()
              : FloatingActionButton(
                  backgroundColor: "B44121".toColor(),
                  onPressed: () {
                    Navigator.pushNamed(context, PageConst.cartPage, arguments: widget.customerEntity);
                  },
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -16, end: -12),
                    badgeContent: Text(
                      "${state.cartItems.length}",
                      style: AppTextStyle.googleFont(
                        "B44121".toColor(),
                        16,
                        FontWeight.bold,
                      ),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.white,
                      padding: EdgeInsets.all(6),
                    ),
                    showBadge: state.cartItems.isNotEmpty,
                    child: const Icon(
                      CupertinoIcons.shopping_cart,
                      size: 32,
                    ),
                  ),
                );
        },
      ),
      appBar: _buildAppBarContent(size, context, widget.customerEntity),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              "รายการร้านอาหาร",
              style: AppTextStyle.googleFont(
                Colors.white,
                24,
                FontWeight.bold,
              ),
            ),
          ),
          TabBar(
            isScrollable: true,
            controller: tabController,
            indicatorColor: Colors.amber.shade900,
            unselectedLabelColor: Colors.grey,
            onTap: (value) {
              setState(() {
                selectedType = restaurantTypes[value];
              });
            },
            tabs: restaurantTypes
                .map(
                  (type) => Tab(
                    child: Text(
                      type,
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListofRestaurants(
                  customerEntity: widget.customerEntity,
                  restaurantType: selectedType,
                ),
                ListofRestaurants(
                  customerEntity: widget.customerEntity,
                  restaurantType: selectedType,
                ),
                ListofRestaurants(
                  customerEntity: widget.customerEntity,
                  restaurantType: selectedType,
                ),
                ListofRestaurants(
                  customerEntity: widget.customerEntity,
                  restaurantType: selectedType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

AppBar _buildAppBarContent(
  Size size,
  BuildContext context,
  CustomerEntity customerEntity,
) {
  return AppBar(
    toolbarHeight: size.height * 0.2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.white,
    flexibleSpace: Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 15,
            ),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: customerEntity.profileUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          100,
                        ),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    "assets/images/image_picker.png",
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/image_picker.png",
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "เลือกร้านที่ชอบได้เลย",
                      style: AppTextStyle.googleFont(
                        Colors.grey,
                        13,
                        FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${customerEntity.username}",
                      style: AppTextStyle.googleFont(
                        Colors.black,
                        14,
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TouchableOpacity(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.favoritePage);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: "B44121".toColor(),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SearchBoxBloc(),
                    child: const SeachBoxView(
                      isNodeFocus: true,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: "D9D9D9".toColor(),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      CupertinoIcons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: CustomText(
                      text: "ค้นหาร้านที่ต้องการ",
                      color: "685A5A".toColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}