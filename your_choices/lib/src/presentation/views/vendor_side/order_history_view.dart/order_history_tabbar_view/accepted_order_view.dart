// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/order_history/order_history_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/date_format.dart';

class AcceptedOrderView extends StatefulWidget {
  final Timestamp timestamp;
  final List<OrderEntity> orders;
  const AcceptedOrderView({
    Key? key,
    required this.timestamp,
    required this.orders,
  }) : super(key: key);

  @override
  State<AcceptedOrderView> createState() => _AcceptedOrderViewState();
}

class _AcceptedOrderViewState extends State<AcceptedOrderView> {
  @override
  void initState() {
    context.read<OrderHistoryCubit>().receiveOrderByDateTime(widget.timestamp);
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
        BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            final List<OrderEntity> orders =
                state.orderEntities.where((element) => element.orderTypes == OrderTypes.accept.toString()).toList();
            if (orders.isEmpty) {
              return Expanded(
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
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OrderEntity order = orders[index];
                return Container(
                  height: 70,
                  margin: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 10,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "${order.customerName}",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text:
                                  "฿ ${order.cartItems?.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice?.toDouble() ?? 0.0)).floor()}",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        CustomText(
                          text: DateConverter.dateTimeFormat(Timestamp.now()).toString(),
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
