// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_state.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/food_detail_view/cubit/food_detail_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/food_detail_view/food_detail_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/show_flutter_toast.dart';
import 'package:your_choices/utilities/text_style.dart';

class RestaurantDetailView extends StatefulWidget {
  final CustomerEntity customerEntity;
  final VendorEntity vendorEntity;
  const RestaurantDetailView({
    Key? key,
    required this.customerEntity,
    required this.vendorEntity,
  }) : super(key: key);

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: size * 0.18,
        child: AppBar(
          automaticallyImplyLeading: false,
          title: _buildTitle(context),
          flexibleSpace: FlexibleSpaceBar(
            background: (widget.vendorEntity.isActive ?? false)
                ? CachedNetworkImage(
                    imageUrl: widget.vendorEntity.resProfileUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.vendorEntity.resProfileUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const CustomText(
                          text: "Close",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderSections(size),
          _buildText(size),
          _buildListofFoods(size),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isNotEmpty) {
            return BottomAppBar(
              elevation: 10,
              height: 85,
              color: Colors.white,
              child: TouchableOpacity(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.cartPage, arguments: widget.customerEntity);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: "FF602E".toColor(),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: BlocBuilder<CartCubit, CartState>(
                                builder: (context, state) {
                                  return CustomText(
                                    text: "${state.cartItems.length}",
                                    color: "FF602E".toColor(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: CustomText(
                                text: "ตระกร้าของฉัน",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            final cartItems = List<CartItemEntity>.from(state.cartItems);
                            num totalPrice = 0;
                            for (var element in cartItems) {
                              num menuTotalPrice = (element.totalPrice ?? 0);
                              totalPrice += menuTotalPrice;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: CustomText(
                                text: "฿$totalPrice",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildHeaderSections(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.2,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  "${widget.vendorEntity.resName}",
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    26,
                    FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  "${widget.vendorEntity.description}",
                  style: AppTextStyle.googleFont(
                    Colors.black54,
                    18,
                    FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Flexible(
                child: Text(
                  "${widget.vendorEntity.restaurantType}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.googleFont(
                    Colors.black54,
                    18,
                    FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (_, state) {
                  final isFavorite = state.vendorEntities.contains(widget.vendorEntity);
                  return IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (isFavorite) {
                        context.read<FavoriteCubit>().onRemoveFavorite(widget.vendorEntity);
                      } else {
                        context.read<FavoriteCubit>().onAddFavorite(widget.vendorEntity);
                      }
                    },
                    icon: Icon(
                      size: 30,
                      color: isFavorite ? Colors.amber.shade900 : Colors.grey.shade800,
                      isFavorite ? Icons.favorite_outlined : Icons.favorite_border_sharp,
                    ),
                  );
                },
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.vendorEntity.onQueue}\n',
                      style: AppTextStyle.googleFont(
                        "FF602E".toColor(),
                        28,
                        FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'คิว ณ ขนะนี้',
                      style: AppTextStyle.googleFont(
                        Colors.black,
                        16,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: "B44121".toColor(),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildText(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 15, left: 17),
      child: Text(
        "รายการอาหาร",
        style: AppTextStyle.googleFont(
          Colors.white,
          26,
          FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListofFoods(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: ListView.separated(
        physics: const ScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        shrinkWrap: true,
        itemCount: widget.vendorEntity.dishes?.length ?? 0,
        itemBuilder: (context, index) {
          final len = widget.vendorEntity.dishes?.length ?? 0;
          final List<DishesEntity>? food = widget.vendorEntity.dishes;
          if (food != null) {
            return TouchableOpacity(
              onTap: (widget.vendorEntity.isActive ?? false) && (food[index].isActive ?? false)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => FoodDetailCubit(),
                            child: FoodDetailView(
                              customerEntity: widget.customerEntity,
                              vendorEntity: widget.vendorEntity,
                              dishesEntity: food[index],
                            ),
                          ),
                        ),
                      );
                    }
                  : !(widget.vendorEntity.isActive ?? false)
                      ? () {
                          showFlutterToast("ช่วงเวลานี้ร้านปิดให้บริการอยู่ โปรดกลับมาภายหลัง");
                        }
                      : (food[index].isActive ?? false)
                          ? null
                          : () {
                              showFlutterToast("เมนูยังไม่จัดให้จำหน่าย โปรดกลับมาภายหลัง");
                            },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.35,
                          height: size.height * 0.13,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              child: (food[index].isActive ?? false)
                                  ? CachedNetworkImage(
                                      imageUrl: food[index].menuImg!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.amber,
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.35,
                                          height: size.height * 0.13,
                                          child: CachedNetworkImage(
                                            imageUrl: food[index].menuImg!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                          ),
                                          child: const CustomText(
                                            text: "Close",
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )),
                        ),
                        Expanded(
                          child: Container(
                            height: size.height * 0.13,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            "${food[index].menuName}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              20,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: size.width * 0.52,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 140,
                                                  child: Text(
                                                    "${food[index].menuDescription}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyle.googleFont(
                                                      Colors.grey.shade500,
                                                      14,
                                                      FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              BlocBuilder<CartCubit, CartState>(
                                                builder: (context, state) {
                                                  return Container(
                                                    width: 40,
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: "B44121".toColor(),
                                                    ),
                                                    child: state.cartItems.isEmpty ||
                                                            state.cartItems
                                                                .where((element) => element.cartId == food[index].dishesId)
                                                                .isEmpty
                                                        ? const Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          )
                                                        : CustomText(
                                                            text:
                                                                "${state.cartItems.where((element) => element.cartId == food[index].dishesId).length}",
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: 70,
                                          child: Text(
                                            "฿ ${food[index].menuPrice}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.googleFont(
                                              "00900E".toColor(),
                                              16,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (len == 0) {
            return const Center(
              child: Text(
                "ไม่มีรายการอาหาร",
              ),
            );
          } else {
            return const Text("ไม่มีรายการอาหาร");
          }
        },
      ),
    );
  }
}
