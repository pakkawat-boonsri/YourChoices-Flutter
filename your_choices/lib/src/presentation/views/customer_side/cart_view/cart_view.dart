import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_divider.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final additional = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "ตะกร้าของฉัน",
        textSize: 22,
        fontWeight: FontWeight.w500,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: state.vendorEntities.length,
                separatorBuilder: (context, index) => const CustomDivider(),
                itemBuilder: (context, index) {
                  VendorEntity vendorEntity = state.vendorEntities[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                children: [
                                  Text(
                                    "ร้านอาหาร : ",
                                    style: AppTextStyle.googleFont(
                                      Colors.white,
                                      18,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${vendorEntity.resName}",
                                        style: AppTextStyle.googleFont(
                                          Colors.white,
                                          18,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: "มี ",
                                          style: AppTextStyle.googleFont(
                                            Colors.white,
                                            18,
                                            FontWeight.normal,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "${vendorEntity.onQueue}",
                                              style: AppTextStyle.googleFont(
                                                "FF602E".toColor(),
                                                18,
                                                FontWeight.normal,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " คิว ณ ขณะนี้",
                                              style: AppTextStyle.googleFont(
                                                Colors.white,
                                                18,
                                                FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox.shrink()),
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: CachedNetworkImageProvider(
                                      "${vendorEntity.resProfileUrl}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const CustomDivider(horizontal: 12),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 5,
                                bottom: 10,
                              ),
                              child: Text(
                                "รายการอาหาร",
                                style: AppTextStyle.googleFont(
                                  Colors.white,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.cartItems.length,
                                  itemBuilder: (context, index) {
                                    CartItemEntity cartItemEntity =
                                        state.cartItems[index];
                                    additional.text =
                                        cartItemEntity.additional ?? "";

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "${cartItemEntity.dishesEntity?.menuImg}",
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                width: size.width * 0.32,
                                                height: size.height * 0.15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: size.width,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CustomText(
                                                      text: cartItemEntity
                                                              .dishesEntity
                                                              ?.menuName ??
                                                          "",
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    CustomText(
                                                      text: cartItemEntity
                                                              .dishesEntity
                                                              ?.menuDescription ??
                                                          "",
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          CupertinoIcons
                                                              .bubble_right,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            onChanged: (value) {
                                                              final newCartItem =
                                                                  cartItemEntity
                                                                      .copyWith(
                                                                          additional:
                                                                              value);
                                                              context
                                                                  .read<
                                                                      CartCubit>()
                                                                  .addAdditionalItemsInCart(
                                                                    newCartItem,
                                                                  );
                                                            },
                                                            controller:
                                                                additional,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            style: AppTextStyle
                                                                .googleFont(
                                                              Colors.grey,
                                                              15,
                                                              FontWeight.w400,
                                                            ),
                                                            decoration:
                                                                InputDecoration
                                                                    .collapsed(
                                                              hintText:
                                                                  "เพิ่มโน็ต...",
                                                              hintStyle:
                                                                  AppTextStyle
                                                                      .googleFont(
                                                                Colors.grey,
                                                                15,
                                                                FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CustomText(
                                                          text:
                                                              "฿ ${cartItemEntity.totalPrice ?? 0}",
                                                          color: "F93C00"
                                                              .toColor(),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        Row(
                                                          children: [
                                                            TouchableOpacity(
                                                              onTap: cartItemEntity
                                                                          .quantity ==
                                                                      1
                                                                  ? () async {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const CustomText(
                                                                              text: "ยืนยันจะลบเมนูนี้หรือไม่",
                                                                              color: Colors.black,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const CustomText(
                                                                                  text: "ยกเลิก",
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  loadingDialog(context);
                                                                                  context.read<CartCubit>().removeItemFromCart(
                                                                                        cartItemEntity: cartItemEntity,
                                                                                      );
                                                                                  Future.delayed(
                                                                                    const Duration(
                                                                                      seconds: 1,
                                                                                    ),
                                                                                  ).then((value) {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: const CustomText(
                                                                                  text: "ยืนยัน",
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  : () {
                                                                      context
                                                                          .read<
                                                                              CartCubit>()
                                                                          .onTappedQuantityDecreasing(
                                                                              cartItemEntity);
                                                                    },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: cartItemEntity
                                                                              .quantity ==
                                                                          1
                                                                      ? Colors
                                                                          .grey
                                                                      : "B44121"
                                                                          .toColor(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: cartItemEntity
                                                                            .quantity ==
                                                                        1
                                                                    ? const Icon(
                                                                        CupertinoIcons
                                                                            .delete,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25,
                                                                      ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
                                                              child: Text(
                                                                "${cartItemEntity.quantity}",
                                                                style: AppTextStyle
                                                                    .googleFont(
                                                                  Colors.black,
                                                                  20,
                                                                  FontWeight
                                                                      .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                              child:
                                                                  TouchableOpacity(
                                                                onTap: () {
                                                                  context
                                                                      .read<
                                                                          CartCubit>()
                                                                      .onTappedQuantityIncreasing(
                                                                          cartItemEntity);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: "B44121"
                                                                        .toColor(),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: "FF602E".toColor(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            const CustomText(
                              text: "ยืนยันคำสั่งซื้อ",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            final cartItems =
                                List<CartItemEntity>.from(state.cartItems);
                            num totalPrice = 0;
                            for (var element in cartItems) {
                              num menuTotalPrice = (element.totalPrice ?? 0) *
                                  (element.quantity ?? 1);
                              totalPrice += menuTotalPrice;
                            }
                            return CustomText(
                              text: "฿$totalPrice",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
