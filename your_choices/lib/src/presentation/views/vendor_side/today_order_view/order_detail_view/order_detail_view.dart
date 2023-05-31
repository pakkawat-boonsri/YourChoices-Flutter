// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/cubit/today_order_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';

class OrderDetailView extends StatefulWidget {
  final OrderEntity orderEntity;
  final String orderType;
  const OrderDetailView({
    Key? key,
    required this.orderEntity,
    required this.orderType,
  }) : super(key: key);

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: TouchableOpacity(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: "B44121".toColor(),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 22,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "ออเดอร์ - ${widget.orderEntity.customerName}",
          style: AppTextStyle.googleFont(
            Colors.black,
            18,
            FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.all(15),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "${widget.orderEntity.customerName}",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    if (widget.orderEntity.orderTypes == OrderTypes.pending.toString()) ...{
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const CustomText(
                            text: "รอดำเนินการ",
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    } else if (widget.orderEntity.orderTypes == OrderTypes.processing.toString()) ...{
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const CustomText(
                            text: "กำลังดำเนินการ",
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    } else ...{
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const CustomText(
                            text: "เมนูเสร็จเรียบร้อย",
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    },
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomText(
                  text: "${DateConverter.dateTimeFormat(widget.orderEntity.createdAt)}",
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomText(
                  text: "รหัสใบสั่งซื้อ: ${widget.orderEntity.orderId!.replaceAll(RegExp(r'-'), '').substring(0, 13)}",
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "รายการอาหาร",
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "ราคา(฿)",
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(thickness: 1),
                      itemCount: widget.orderEntity.cartItems?.length ?? 0,
                      itemBuilder: (context, index) {
                        CartItemEntity cartItem = widget.orderEntity.cartItems![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          height: 75,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 65,
                                height: 60,
                                child: CachedNetworkImage(
                                  imageUrl: cartItem.dishesEntity?.menuImg ?? "",
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      CustomText(
                                        text: cartItem.dishesEntity?.menuName ?? "",
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      cartItem.dishesEntity!.filterOption!.every((filter) {
                                        final isRadioSelected = filter.selectedAddOnRadioListTile != null;
                                        final isCheckboxSelected = filter.selectedAddOnCheckBoxListTile != null &&
                                            filter.selectedAddOnCheckBoxListTile!.isNotEmpty;

                                        return !isRadioSelected && !isCheckboxSelected;
                                      })
                                          ? const CustomText(
                                              text: "ไม่มีตัวเลือกสินค้า",
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            )
                                          : Wrap(
                                              children: cartItem.dishesEntity?.filterOption?.map((filter) {
                                                    if (filter.selectedAddOnCheckBoxListTile != null &&
                                                        (filter.selectedAddOnCheckBoxListTile?.isNotEmpty ?? false)) {
                                                      return Wrap(
                                                        children: filter.selectedAddOnCheckBoxListTile!
                                                            .map((addOn) => CustomText(
                                                                  text:
                                                                      "${addOn.addonsName}${addOn != filter.selectedAddOnCheckBoxListTile!.last ? "" : ","}",
                                                                  color: Colors.grey,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.normal,
                                                                ))
                                                            .toList(),
                                                      );
                                                    } else if (filter.selectedAddOnCheckBoxListTile == null ||
                                                        filter.selectedAddOnCheckBoxListTile!.isEmpty) {
                                                      return filter.selectedAddOnRadioListTile != null
                                                          ? CustomText(
                                                              text:
                                                                  "${filter.selectedAddOnRadioListTile!.addonsName}${filter.selectedAddOnRadioListTile == cartItem.dishesEntity?.filterOption?.last.selectedAddOnRadioListTile ? "" : ","}",
                                                              color: Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.normal,
                                                            )
                                                          : Container();
                                                    } else {
                                                      return Container();
                                                    }
                                                  }).toList() ??
                                                  [],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    margin: const EdgeInsets.only(bottom: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      "x${cartItem.quantity}",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        14,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        18,
                                        FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "฿ ",
                                          style: AppTextStyle.googleFont(
                                            Colors.amber.shade900,
                                            18,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${cartItem.totalPrice}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "ราคาทั้งหมด",
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      Text.rich(
                        TextSpan(
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            18,
                            FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: "฿ ",
                              style: AppTextStyle.googleFont(
                                Colors.amber.shade900,
                                18,
                                FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: (widget.orderEntity.cartItems?.fold<double>(
                                      0, (previousValue, element) => previousValue + element.totalPrice!.toDouble()))
                                  ?.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.orderEntity.orderTypes == OrderTypes.pending.toString()) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TouchableOpacity(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const CustomText(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    text: "ต้องการยกเลิกออเดอร์นี้หรือไม่?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const CustomText(
                                        text: "ยกเลิก",
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        loadingDialog(context);
                                        await context.read<TodayOrderCubit>().deleteOrder(widget.orderEntity);

                                        Future.delayed(const Duration(seconds: 1)).then((value) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const CustomText(
                                        text: "ยืนยัน",
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "ยกเลิกออเดอร์",
                              style: AppTextStyle.googleFont(
                                Colors.white,
                                20,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        TouchableOpacity(
                          onTap: () {
                            loadingDialog(context);
                            final newOrderEntity = widget.orderEntity.copyWith(orderTypes: OrderTypes.processing.toString());
                            context.read<TodayOrderCubit>().confirmOrder(newOrderEntity);

                            Future.delayed(const Duration(milliseconds: 800)).then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade900,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "ยืนยันออเดอร์",
                              style: AppTextStyle.googleFont(
                                Colors.white,
                                20,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  } else if (widget.orderEntity.orderTypes == OrderTypes.processing.toString()) ...{
                    TouchableOpacity(
                      onTap: () {
                        loadingDialog(context);
                        final newOrderEntity = widget.orderEntity.copyWith(orderTypes: OrderTypes.completed.toString());
                        context.read<TodayOrderCubit>().confirmOrder(newOrderEntity);

                        Future.delayed(const Duration(milliseconds: 800)).then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "อาหารพร้อมรับ",
                          style: AppTextStyle.googleFont(
                            Colors.white,
                            20,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  } else ...{
                    TouchableOpacity(
                      onTap: () {
                        // loadingDialog(context);

                        // Future.delayed(const Duration(milliseconds: 800)).then((value) {
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        // });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "จัดเก็บประวัติคำสั่งซื้อ",
                          style: AppTextStyle.googleFont(
                            Colors.white,
                            20,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
