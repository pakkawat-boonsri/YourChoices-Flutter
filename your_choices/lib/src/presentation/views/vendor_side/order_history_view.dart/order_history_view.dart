import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/order_history/order_history_cubit.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_tabbar_view/accepted_order_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_tabbar_view/cancel_order_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';

import '../../../../../utilities/date_format.dart';
import '../../../../../utilities/text_style.dart';
import '../../../widgets/custom_vendor_appbar.dart';

class OrderHistoryView extends StatefulWidget {
  final VendorEntity vendorEntity;
  const OrderHistoryView({
    super.key,
    required this.vendorEntity,
  });

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> with SingleTickerProviderStateMixin {
  late VendorEntity vendorEntity;
  late TabController tabController;
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    vendorEntity = widget.vendorEntity;
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    context.read<OrderHistoryCubit>().receiveOrderByDateTime(Timestamp.fromDate(DateTime.now()));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "ประวัติการสั่งซื้อ",
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderTitles(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          _buildTotalSellPriceByDate(),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TabBar(
              controller: tabController,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.read<OrderHistoryCubit>().receiveOrderByDateTime(Timestamp.fromDate(currentDate));

                    break;
                  case 1:
                    context.read<OrderHistoryCubit>().receiveOrderByDateTime(Timestamp.fromDate(currentDate));
                    break;
                  default:
                }
              },
              indicatorColor: Colors.amber.shade900,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: Text(
                    "ออเดอร์ที่รับ",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "ออเดอร์ที่ยกเลิก",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: tabController,
              children: [
                BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                  builder: (context, state) {
                    if (state is OrderHistoryLoading) {
                      return SizedBox(
                        width: size.width,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      );
                    } else if (state is OrderHistoryLoaded) {
                      return AcceptedOrderView(orders: state.orderEntities);
                    } else {
                      return Container();
                    }
                  },
                ),
                BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                  builder: (context, state) {
                    if (state is OrderHistoryLoading) {
                      return SizedBox(
                        width: size.width,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      );
                    } else if (state is OrderHistoryLoaded) {
                      return CancelOrderView(orders: state.orderEntities);
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTotalSellPriceByDate() {
    return Column(
      children: [
        const CustomText(
          text: "สรุปยอดขายรายวัน",
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              );
            } else if (state is OrderHistoryLoaded) {
              return tabController.index == 0
                  ? CustomText(
                      text:
                          "฿ ${state.orderEntities.where((element) => element.orderTypes == OrderTypes.completed.toString() || element.orderTypes == OrderTypes.collectToHistory.toString()).fold(0.0, (previousValue, element) => previousValue + (element.cartItems!.fold(0.0, (previousValue, element) => previousValue! + element.totalPrice!.toDouble()) ?? 0)).toDouble().floor()}",
                      color: Colors.green,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    )
                  : CustomText(
                      text:
                          "฿ ${state.orderEntities.where((element) => element.orderTypes == OrderTypes.failure.toString()).fold(0.0, (previousValue, element) => previousValue + (element.cartItems!.fold(0.0, (previousValue, element) => previousValue! + element.totalPrice!.toDouble()) ?? 0)).toDouble().floor()}",
                      color: Colors.red,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    );
            } else {
              return Container();
            }
          },
        ),
        TouchableOpacity(
          onTap: () async {
            final accountCreatedDate = vendorEntity.accountCreatedWhen!.toDate();

            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: accountCreatedDate.isAfter(currentDate) ? accountCreatedDate : currentDate,
              firstDate: accountCreatedDate,
              lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
              helpText: 'วันสรุปยอดขาย',
              confirmText: "ยืนยัน",
              cancelText: "ยกเลิก",
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.amber.shade900,
                      onPrimary: Colors.white,
                      surface: const Color(0xFF34312f),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
              selectableDayPredicate: (day) =>
                  day.isAfter(accountCreatedDate.subtract(const Duration(days: 1))) && day.isBefore(DateTime.now()),
            );

            if (picked != null && picked != currentDate) {
              setState(() {
                currentDate = picked;
              });
              if (context.mounted) {
                context.read<OrderHistoryCubit>().receiveOrderByDateTime(Timestamp.fromDate(currentDate));
              }
            }
          },
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: DateConverter.dateFormat(Timestamp.fromDate(currentDate))!,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderTitles() {
    return Container(
      height: 100,
      // color: Colors.amber,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                vendorEntity.resName ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  20,
                  FontWeight.bold,
                ),
              ),
              Text(
                vendorEntity.username ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  15,
                  FontWeight.normal,
                ),
              ),
              Text(
                vendorEntity.restaurantType ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  15,
                  FontWeight.normal,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    vendorEntity.profileUrl ?? "",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
