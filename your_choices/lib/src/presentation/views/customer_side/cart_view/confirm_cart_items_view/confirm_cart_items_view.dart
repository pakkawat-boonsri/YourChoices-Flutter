// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:uuid/uuid.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_account_balance_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_main_view/customer_main_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_divider.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/show_flutter_toast.dart';
import 'package:your_choices/utilities/text_style.dart';

class ConfirmCartItemsView extends StatefulWidget {
  final CustomerEntity customerEntity;
  final List<VendorEntity> vendorEntities;
  final List<CartItemEntity> cartItemEntities;
  const ConfirmCartItemsView({
    Key? key,
    required this.customerEntity,
    required this.vendorEntities,
    required this.cartItemEntities,
  }) : super(key: key);

  @override
  State<ConfirmCartItemsView> createState() => _ConfirmCartItemsViewState();
}

class _ConfirmCartItemsViewState extends State<ConfirmCartItemsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: "ยืนยันคำสั่งซื้อ",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 15),
            child: CustomText(
              text: "รายการคำสั่งซื้อ",
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const CustomDivider(
            horizontal: 8,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.vendorEntities.length,
            itemBuilder: (context, index) {
              final vendorEntity = widget.vendorEntities[index];
              final List<CartItemEntity> cartItems =
                  widget.cartItemEntities.where((element) => element.vendorId == vendorEntity.uid).toList();
              return Column(
                children: [
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListTile(
                      title: CustomText(
                        text: vendorEntity.resName ?? "",
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: CustomText(
                        text: vendorEntity.description ?? "",
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, cartIndex) {
                      final cartItem = cartItems[cartIndex];
                      return Container(
                        color: Colors.grey.shade100,
                        padding: cartItem.dishesEntity!.filterOption!.every((filter) {
                          final isRadioSelected = filter.selectedAddOnRadioListTile != null;
                          final isCheckboxSelected = filter.selectedAddOnCheckBoxListTile != null &&
                              filter.selectedAddOnCheckBoxListTile!.isNotEmpty;

                          return !isRadioSelected && !isCheckboxSelected;
                        })
                            ? const EdgeInsets.symmetric(vertical: 4)
                            : const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          // dense: true,
                          leading: CircleAvatar(
                            radius: 23,
                            foregroundImage: CachedNetworkImageProvider(cartItem.dishesEntity?.menuImg ?? ""),
                            backgroundColor: Colors.transparent,
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
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
                              ),
                              Expanded(
                                child: CustomText(
                                  text: "฿ ${cartItem.totalPrice?.toStringAsFixed(2)}",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          title: CustomText(
                            text: cartItem.dishesEntity?.menuName ?? "",
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          subtitle: cartItem.dishesEntity!.filterOption!.every((filter) {
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
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
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
                      20,
                      FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "฿ ",
                        style: AppTextStyle.googleFont(
                          Colors.amber.shade900,
                          20,
                          FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: (widget.cartItemEntities
                                .fold<double>(0, (previousValue, element) => previousValue + element.totalPrice!.toDouble()))
                            .toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        height: 85,
        child: TouchableOpacity(
          onTap: () async {
            loadingDialog(context);
            List<CartItemEntity> newCartItems = [];
            final accountBalance = await di.sl<GetAccountBalanceUseCase>().call(widget.customerEntity.uid ?? "");
            if (accountBalance <
                widget.cartItemEntities.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice ?? 0))) {
              if (context.mounted) {
                Navigator.pop(context);
              }
              showFlutterToast("เงินในบัญชีไม่พอสำหรับการสั่งอาหาร โปรดเติมเงินเข้าระบบ");
              return;
            }

            for (var vendorEntity in widget.vendorEntities) {
              newCartItems = List<CartItemEntity>.from(
                widget.cartItemEntities
                    .where(
                      (element) => (element.vendorId ?? false) == vendorEntity.uid,
                    )
                    .toList(),
              );

              final confirmOrderEntity = ConfirmOrderEntity(
                vendorEntity: vendorEntity,
                orderId: const Uuid().v4(),
                customerId: widget.customerEntity.uid,
                customerName: widget.customerEntity.username,
                restaurantId: vendorEntity.uid,
                cartItems: newCartItems,
                createdAt: Timestamp.now(),
                orderTypes: OrderTypes.pending.toString(),
              );
              for (var cartItem in newCartItems) {
                final newTransactionEntity = TransactionEntity(
                  id: const Uuid().v4(),
                  customerId: widget.customerEntity.uid ?? "",
                  date: Timestamp.now(),
                  type: "paid",
                  menuName: cartItem.dishesEntity?.menuName ?? "",
                  resName: vendorEntity.resName,
                  totalPrice: cartItem.totalPrice,

                );

                if (context.mounted) {
                  await context.read<CustomerCubit>().createTransaction(newTransactionEntity);
                }
              }

              if (context.mounted) {
                await context.read<CartCubit>().sendConfirmOrderToRestaurant(confirmOrderEntity);
              }
            }

            await Future.delayed(const Duration(milliseconds: 1500)).then((value) {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerMainView(uid: widget.customerEntity.uid ?? ""),
                ),
                (route) => false,
              );
              context.read<CartCubit>().clearCart();
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
                        child: CustomText(
                          text: "${widget.cartItemEntities.length}",
                          color: "FF602E".toColor(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: CustomText(
                          text: "สั่งซื้ออาหาร",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: CustomText(
                      text:
                          "฿${widget.cartItemEntities.fold(0.00, (previousValue, element) => previousValue + element.totalPrice!.toDouble()).toStringAsFixed(2)}",
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
      ),
    );
  }
}
