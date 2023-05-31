// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/order_detail_view/order_detail_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';

class NewOrderView extends StatefulWidget {
  final List<OrderEntity> orderEntities;
  const NewOrderView({
    Key? key,
    required this.orderEntities,
  }) : super(key: key);

  @override
  State<NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends State<NewOrderView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.grey[350],
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.orderEntities.length,
          itemBuilder: (context, index) {
            OrderEntity orderEntity = widget.orderEntities[index];
            final orderId = orderEntity.orderId;
            final shortId = orderId!.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 4);
            return Container(
              width: size.width,
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailView(
                        orderEntity: orderEntity,
                        orderType: orderEntity.orderTypes!,
                      ),
                    ),
                  );
                },
                visualDensity: VisualDensity.adaptivePlatformDensity,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                leading: Container(
                  alignment: Alignment.center,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.6),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "OrderId :",
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: "ID$shortId",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                title: CustomText(
                  text: "${orderEntity.customerName}",
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                subtitle: Row(
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
                    CustomText(
                      text: orderEntity.orderTypes == OrderTypes.pending.toString() ? "รอดำเนินการ" : "",
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                trailing: CustomText(
                  text:
                      "฿ ${orderEntity.cartItems!.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice ?? 0)).toStringAsFixed(2)}",
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
