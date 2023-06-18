import 'package:flutter/material.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/order_detail_view/order_detail_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/height_container.dart';

class InProgessOrderView extends StatefulWidget {
  final List<OrderEntity> orderEntities;
  const InProgessOrderView({
    Key? key,
    required this.orderEntities,
  }) : super(key: key);

  @override
  State<InProgessOrderView> createState() => _InProgessOrderViewState();
}

class _InProgessOrderViewState extends State<InProgessOrderView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: widget.orderEntities.isNotEmpty
          ? Column(
              children: [
                const HeightContainer(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.orderEntities.length,
                  itemBuilder: (context, index) {
                    OrderEntity orderEntity = widget.orderEntities[index];
                    final orderId = orderEntity.orderId;
                    final shortId = orderId!.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 4);
                    return Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                              text: orderEntity.orderTypes == OrderTypes.processing.toString() ? "กำลังดำเนินการ" : "",
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
              ],
            )
          : SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "assets/images/order_food.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: "คุณยังไม่มีรายการออเดอร์ที่กำลังจัดทำ",
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
    );
  }
}
