// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/customer_order/customer_order_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_order_detail_view/customer_order_detail_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/height_container.dart';

class CustomerOrderPendingView extends StatefulWidget {
  final String uid;
  const CustomerOrderPendingView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<CustomerOrderPendingView> createState() => _CustomerOrderPendingViewState();
}

class _CustomerOrderPendingViewState extends State<CustomerOrderPendingView> {
  @override
  void initState() {
    BlocProvider.of<CustomerOrderCubit>(context).receiveOrderFromRestaurant(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: CustomText(
              text: "รายการคำสั่งซื้อ",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          BlocBuilder<CustomerOrderCubit, CustomerOrderState>(builder: (context, state) {
            if (state is CustomerOrderLoading) {
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber.shade900,
                  ),
                ),
              );
            } else if (state is CustomerOrderLoaded) {
              final List<ConfirmOrderEntity> confirmOrderEntities = state.confirmOrderEntities
                  .where((element) =>
                      element.orderTypes == OrderTypes.accept.toString() ||
                      element.orderTypes == OrderTypes.pending.toString() ||
                      element.orderTypes == OrderTypes.processing.toString())
                  .toList();
              confirmOrderEntities.sort(
                (a, b) {
                  final newA = a.createdAt!.toDate();
                  final newB = b.createdAt!.toDate();
                  return newB.compareTo(newA);
                },
              );
              if (confirmOrderEntities.isEmpty) {
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
                            "assets/images/order_food.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CustomText(
                          text: "คุณยังไม่มีคำสั่งซื้อใดๆ",
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const HeightContainer(height: 10),
                    itemCount: confirmOrderEntities.length,
                    itemBuilder: (context, index) {
                      final ConfirmOrderEntity confirmOrderEntity = confirmOrderEntities[index];
                      final orderId = confirmOrderEntity.orderId ?? "";
                      final shortId = orderId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 4);
                      return TouchableOpacity(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerOrderDetailView(confirmOrderEntity: confirmOrderEntity),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.grey.shade100,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.amber.shade900.withOpacity(0.1),
                                              border: Border.all(
                                                color: Colors.amber.shade900,
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
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              CustomText(
                                                text: confirmOrderEntity.vendorEntity?.resName ?? "",
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              Wrap(
                                                children: confirmOrderEntity.cartItems
                                                        ?.map((cartItem) => CustomText(
                                                              text:
                                                                  "${cartItem.dishesEntity?.menuName}${confirmOrderEntity.cartItems?.last == cartItem ? "" : " , "}",
                                                              color: Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ))
                                                        .toList() ??
                                                    [],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 7,
                                                    height: 7,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: CustomText(
                                                      text: confirmOrderEntity.orderTypes == OrderTypes.pending.toString()
                                                          ? "กำลังรอรับออเดอร์"
                                                          : confirmOrderEntity.orderTypes == OrderTypes.accept.toString()
                                                              ? "ออเดอร์ได้รับการยอมรับ"
                                                              : confirmOrderEntity.orderTypes ==
                                                                      OrderTypes.processing.toString()
                                                                  ? "กำลังทำการปรุงอาหาร"
                                                                  : "",
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                          text: "฿ ",
                                          color: Colors.amber.shade900,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        CustomText(
                                          text:
                                              "${confirmOrderEntity.cartItems?.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice?.toDouble() ?? 0)).toStringAsFixed(0)}",
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
            return Container();
          }),
        ],
      ),
    );
  }
}
