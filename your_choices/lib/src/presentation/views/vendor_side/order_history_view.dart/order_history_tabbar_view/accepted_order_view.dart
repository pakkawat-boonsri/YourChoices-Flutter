// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/height_container.dart';
import 'package:your_choices/utilities/width_container.dart';

class AcceptedOrderView extends StatefulWidget {
  final List<OrderEntity> orders;
  const AcceptedOrderView({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  State<AcceptedOrderView> createState() => _AcceptedOrderViewState();
}

class _AcceptedOrderViewState extends State<AcceptedOrderView> {
  late final List<OrderEntity> orders;

  @override
  void initState() {
    orders = widget.orders.where((element) => element.orderTypes == OrderTypes.collectToHistory.toString()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, right: 10, top: 10),
          child: const CustomText(
            text: "รายการที่รับ",
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (orders.isEmpty) ...[
          Expanded(
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "assets/images/transaction_history.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: "ไม่มีรายการออเดอร์ที่รับ ณ ขณะนี้",
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          )
        ] else ...[
          const HeightContainer(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OrderEntity order = orders[index];
                final orderId = order.orderId;
                final shortId = orderId!.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 4);
                return Container(
                  height: 70,
                  margin: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 5,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                          color: Colors.green,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: "OrderId :",
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            CustomText(
                              text: "ID$shortId",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ],
                        ),
                      ),
                      const WidthContainer(width: 10),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: "${order.customerName}",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: DateConverter.dateTimeFormat(order.createdAt).toString(),
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      CustomText(
                        text:
                            "฿ ${order.cartItems?.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice?.toDouble() ?? 0.0)).floor()}",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      const WidthContainer(width: 10),
                    ],
                  ),
                );
              },
            ),
          )
        ]
      ],
    );
  }
}
