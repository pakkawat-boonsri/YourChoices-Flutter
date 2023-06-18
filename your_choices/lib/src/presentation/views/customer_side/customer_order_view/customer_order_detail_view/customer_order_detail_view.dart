// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/text_style.dart';

class CustomerOrderDetailView extends StatefulWidget {
  final ConfirmOrderEntity confirmOrderEntity;
  const CustomerOrderDetailView({
    Key? key,
    required this.confirmOrderEntity,
  }) : super(key: key);

  @override
  State<CustomerOrderDetailView> createState() => _CustomerOrderDetailViewState();
}

class _CustomerOrderDetailViewState extends State<CustomerOrderDetailView> {
  checkOrderTypes(String orderType) {
    switch (orderType) {
      case "OrderTypes.pending":
        return "กำลังรอรับออเดอร์";
      case "OrderTypes.processing":
        return "กำลังทำการปรุงอาหาร";
      case "OrderTypes.completed":
        return "ออเดอร์สำเร็จเรียบร้อย";
      case "OrderTypes.failure":
        return "ออเดอร์ถูกยกเลิกหรือเกิดข้อผิดพลาดขึ้น";
      default:
        "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        textSize: 19,
        title: "ออเดอร์ร้าน - ${widget.confirmOrderEntity.vendorEntity?.resName ?? ""}",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Order No.",
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  text: "YCF-${widget.confirmOrderEntity.orderId?.replaceAll(RegExp(r'[^0-9]'), '').split("-")[0]}",
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.confirmOrderEntity.vendorEntity?.resName ?? "",
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomText(
                    text: "${DateConverter.dateTimeFormat(widget.confirmOrderEntity.createdAt)}",
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: checkOrderTypes(widget.confirmOrderEntity.orderTypes ?? "") ==
                                  "ออเดอร์ถูกยกเลิกหรือเกิดข้อผิดพลาดขึ้น"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        text: "${checkOrderTypes(widget.confirmOrderEntity.orderTypes ?? "")}",
                        color: checkOrderTypes(widget.confirmOrderEntity.orderTypes ?? "") ==
                                "ออเดอร์ถูกยกเลิกหรือเกิดข้อผิดพลาดขึ้น"
                            ? Colors.red
                            : Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  ),
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
                      itemCount: widget.confirmOrderEntity.cartItems?.length ?? 0,
                      itemBuilder: (context, index) {
                        CartItemEntity cartItem = widget.confirmOrderEntity.cartItems![index];
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
                              text: (widget.confirmOrderEntity.cartItems?.fold<double>(
                                      0, (previousValue, element) => previousValue + element.totalPrice!.toDouble()))
                                  ?.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
