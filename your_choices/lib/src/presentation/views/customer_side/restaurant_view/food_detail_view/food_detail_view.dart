// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/food_detail_view/cubit/food_detail_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_divider.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../widgets/custom_back_arrow.dart';

class FoodDetailView extends StatefulWidget {
  final CustomerEntity customerEntity;
  final VendorEntity vendorEntity;
  final DishesEntity dishesEntity;
  const FoodDetailView({
    Key? key,
    required this.customerEntity,
    required this.vendorEntity,
    required this.dishesEntity,
  }) : super(key: key);

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  final additional = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FoodDetailCubit>().init(widget.dishesEntity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            title: const CustomBackArrow(),
            expandedHeight: 150,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.dishesEntity.menuImg!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: Text(
                    "${widget.dishesEntity.menuName}",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      32,
                      FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    "${widget.dishesEntity.menuDescription}",
                    style: AppTextStyle.googleFont(
                      Colors.black54,
                      16,
                      FontWeight.w500,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                BlocBuilder<FoodDetailCubit, FoodDetailState>(
                  builder: (context, state) {
                    return state.filters.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: Text(
                              "ตัวเลือกที่จะบวกเพิ่ม",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                20,
                                FontWeight.w600,
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<FoodDetailCubit, FoodDetailState>(
                  builder: (context, state) {
                    return ExpansionPanelList(
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (panelIndex, isExpanded) {
                        context.read<FoodDetailCubit>().onExpansionPanelTapped(panelIndex, isExpanded);
                      },
                      children: state.filters
                          .map(
                            (filter) => ExpansionPanel(
                              canTapOnHeader: true,
                              isExpanded: filter.isExpanded,
                              headerBuilder: (context, isExpanded) => ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      "${filter.filterName}  ",
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        18,
                                        FontWeight.w500,
                                      ),
                                    ),
                                    (filter.isRequired) ?? false
                                        ? Text(
                                            "(is Required)",
                                            style: AppTextStyle.googleFont(
                                              Colors.black54,
                                              14,
                                              FontWeight.normal,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (filter.isRequired == true && filter.addOns != null) ...[
                                    ...filter.addOns!.map(
                                      (addOn) => RadioListTile(
                                        dense: true,
                                        // key: ValueKey(filter.filterId),
                                        activeColor: Colors.amber.shade900,
                                        value: addOn,
                                        groupValue: filter.selectedAddOnRadioListTile,
                                        onChanged: (value) {
                                          final filterIndex = state.filters.indexOf(filter);

                                          context.read<FoodDetailCubit>().onTappedRadioListTile(
                                                filterIndex,
                                                filter,
                                                value,
                                              );
                                        },
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        title: Text(
                                          "${addOn.addonsName}",
                                          style: AppTextStyle.googleFont(
                                            Colors.black,
                                            15,
                                            FontWeight.w500,
                                          ),
                                        ),
                                        secondary: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            addOn.price == null
                                                ? Text(
                                                    "0 ฿",
                                                    style: AppTextStyle.googleFont(
                                                      Colors.black,
                                                      15,
                                                      FontWeight.w500,
                                                    ),
                                                  )
                                                : addOn.priceType == "RadioTypes.priceIncrease"
                                                    ? Text(
                                                        "+",
                                                        style: AppTextStyle.googleFont(
                                                          Colors.black,
                                                          15,
                                                          FontWeight.w500,
                                                        ),
                                                      )
                                                    : Text(
                                                        "-",
                                                        style: AppTextStyle.googleFont(
                                                          Colors.black,
                                                          15,
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                            addOn.price == null
                                                ? const Text("")
                                                : addOn.priceType == "RadioTypes.priceIncrease"
                                                    ? Text(
                                                        "${addOn.price ?? ""} ฿",
                                                        style: AppTextStyle.googleFont(
                                                          Colors.black,
                                                          15,
                                                          FontWeight.w500,
                                                        ),
                                                      )
                                                    : Text(
                                                        "${addOn.price ?? ""} ฿",
                                                        style: AppTextStyle.googleFont(
                                                          Colors.black,
                                                          15,
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Add CheckboxListTile widgets here for optional and multiple filters
                                  ] else if (filter.isMultiple == true && filter.addOns != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: CustomText(
                                        text: "เลือกได้สูงสุด ${filter.multipleQuantity} ตัวเลือก",
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    ...filter.addOns!.map(
                                      (addOn) => Column(
                                        children: [
                                          CheckboxListTile(
                                            dense: true,
                                            enabled: state.isEnable || addOn.isSelected,
                                            // key: ValueKey(filter.filterId),
                                            checkColor: Colors.white,
                                            activeColor: Colors.amber.shade900,

                                            controlAffinity: ListTileControlAffinity.leading,
                                            value: addOn.isSelected,

                                            onChanged: (selected) {
                                              final filterIndex = state.filters.indexOf(filter);

                                              context.read<FoodDetailCubit>().onTappedCheckboxListTile(filterIndex, addOn);
                                            },
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            title: Text(
                                              "${addOn.addonsName}",
                                              style: AppTextStyle.googleFont(
                                                state.isEnable || addOn.isSelected ? Colors.black : Colors.grey,
                                                15,
                                                FontWeight.w500,
                                              ),
                                            ),
                                            secondary: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                addOn.price == null
                                                    ? Text(
                                                        "0 ฿",
                                                        style: AppTextStyle.googleFont(
                                                          state.isEnable || addOn.isSelected ? Colors.black : Colors.grey,
                                                          15,
                                                          FontWeight.w500,
                                                        ),
                                                      )
                                                    : addOn.priceType == "RadioTypes.priceIncrease"
                                                        ? Text(
                                                            "+",
                                                            style: AppTextStyle.googleFont(
                                                              state.isEnable || addOn.isSelected
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              15,
                                                              FontWeight.w500,
                                                            ),
                                                          )
                                                        : Text(
                                                            "-",
                                                            style: AppTextStyle.googleFont(
                                                              state.isEnable || addOn.isSelected
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              15,
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                                addOn.price == null
                                                    ? const Text("")
                                                    : addOn.priceType == "RadioTypes.priceIncrease"
                                                        ? Text(
                                                            "${addOn.price ?? ""} ฿",
                                                            style: AppTextStyle.googleFont(
                                                              state.isEnable || addOn.isSelected
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              15,
                                                              FontWeight.w500,
                                                            ),
                                                          )
                                                        : Text(
                                                            "${addOn.price ?? ""} ฿",
                                                            style: AppTextStyle.googleFont(
                                                              state.isEnable || addOn.isSelected
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              15,
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CustomDivider(),
                ),
                BlocBuilder<FoodDetailCubit, FoodDetailState>(
                  builder: (context, state) {
                    return Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text(
                              "ทานนี้",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                18,
                                FontWeight.w500,
                              ),
                            ),
                            visualDensity: VisualDensity.adaptivePlatformDensity,
                            activeColor: Colors.amber.shade900,
                            value: EatHereOrTakeHome.eatHere.toString(),
                            groupValue: state.eatHereOrTakeHome,
                            onChanged: (value) {
                              context.read<FoodDetailCubit>().onTappedEatHereOrTakeHome(value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text(
                              "กลับบ้าน",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                18,
                                FontWeight.w500,
                              ),
                            ),
                            activeColor: Colors.amber.shade900,
                            value: EatHereOrTakeHome.takeHome.toString(),
                            groupValue: state.eatHereOrTakeHome,
                            onChanged: (value) {
                              context.read<FoodDetailCubit>().onTappedEatHereOrTakeHome(value);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CustomDivider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "คำขอเพิ่มเติม",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    bottom: 15,
                  ),
                  child: TextField(
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      16,
                      FontWeight.w500,
                    ),
                    controller: additional,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      isDense: true,
                      hintText: "เผ็ดๆๆๆๆ เผ็ดมากๆๆ เผ็ดแบบเผ็ดตายไปเลย",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        height: 80,
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  BlocBuilder<FoodDetailCubit, FoodDetailState>(
                    builder: (context, state) {
                      return TouchableOpacity(
                        onTap: state.quantity == 1
                            ? null
                            : () {
                                context.read<FoodDetailCubit>().onTappedQuantityDecreasing();
                              },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: state.quantity == 1 ? Colors.grey : "B44121".toColor(),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<FoodDetailCubit, FoodDetailState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "${state.quantity}",
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            20,
                            FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TouchableOpacity(
                      onTap: () {
                        context.read<FoodDetailCubit>().onTappedQuantityIncreasing();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: "B44121".toColor(),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<FoodDetailCubit, FoodDetailState>(
              builder: (context, state) {
                if (state.additionalPrice.isEmpty) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TouchableOpacity(
                        onTap: state.isSelectRequireFilters.every(
                          (element) => element == true,
                        )
                            ? () {
                                loadingDialog(context);
                                final cartItem = CartItemEntity(
                                  additional: additional.text.isEmpty ? "" : additional.text,
                                  cartId: widget.dishesEntity.dishesId,
                                  eatHereOrTakeHome: state.eatHereOrTakeHome,
                                  quantity: state.quantity,
                                  vendorId: widget.vendorEntity.uid,
                                  dishesEntity: widget.dishesEntity.copyWith(
                                    filterOption: state.filters,
                                  ),
                                  basePrice: ((widget.dishesEntity.menuPrice ?? 0)),
                                  totalPrice: ((widget.dishesEntity.menuPrice ?? 0)) * state.quantity,
                                );

                                context.read<CartCubit>().addItemToCart(
                                      vendorEntity: widget.vendorEntity,
                                      cartItemEntity: cartItem,
                                    );
                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: state.isSelectRequireFilters.every(
                              (element) => element == true,
                            )
                                ? "FF602E".toColor()
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "เพิ่มลงตะกร้า",
                                style: AppTextStyle.googleFont(
                                  Colors.white,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                              BlocBuilder<FoodDetailCubit, FoodDetailState>(
                                builder: (context, state) {
                                  return Text(
                                    "฿ ${(widget.dishesEntity.menuPrice ?? 0) * state.quantity}",
                                    style: AppTextStyle.googleFont(
                                      Colors.white,
                                      20,
                                      FontWeight.w500,
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
                  final currentAdditional = List<num>.from(state.additionalPrice);
                  final sum = currentAdditional.reduce(
                    (value, element) => (value.toDouble() + element.toDouble()),
                  );
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TouchableOpacity(
                        onTap: state.isSelectRequireFilters.every(
                          (element) => element == true,
                        )
                            ? () {
                                loadingDialog(context);
                                final cartItem = CartItemEntity(
                                  additional: additional.text.isEmpty ? "" : additional.text,
                                  cartId: widget.dishesEntity.dishesId,
                                  eatHereOrTakeHome: state.eatHereOrTakeHome,
                                  quantity: state.quantity,
                                  vendorId: widget.vendorEntity.uid,
                                  dishesEntity: widget.dishesEntity.copyWith(
                                    filterOption: state.filters,
                                  ),
                                  basePrice: ((widget.dishesEntity.menuPrice ?? 0) + sum.floor()),
                                  totalPrice: ((widget.dishesEntity.menuPrice ?? 0) + sum.floor()) * state.quantity,
                                );

                                context.read<CartCubit>().addItemToCart(
                                      vendorEntity: widget.vendorEntity,
                                      cartItemEntity: cartItem,
                                    );
                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: state.isSelectRequireFilters.every(
                              (element) => element == true,
                            )
                                ? "FF602E".toColor()
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "เพิ่มลงตะกร้า",
                                style: AppTextStyle.googleFont(
                                  Colors.white,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                "฿ ${((widget.dishesEntity.menuPrice ?? 0) + sum.floor()) * state.quantity}",
                                style: AppTextStyle.googleFont(
                                  Colors.white,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
