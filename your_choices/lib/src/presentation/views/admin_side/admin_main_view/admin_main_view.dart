// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/presentation/blocs/admin_bloc/admin_cubit.dart';
import 'package:your_choices/src/presentation/blocs/utilities_bloc/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/views/admin_side/qr_code_scanner_view/qr_code_scanner_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/height_container.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class AdminMainView extends StatefulWidget {
  final String uid;
  const AdminMainView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    context.read<AdminCubit>().getAdminTransaction(Timestamp.fromDate(currentDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: PopupMenuButton(
              child: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => BlocProvider.of<AuthCubit>(context).loggingOut(),
                  child: const CustomText(
                    text: "ออกจากระบบ",
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            title: const CustomText(
              text: "Admin Panel",
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            actions: [
              IconButton(
                tooltip: "Select to Scan QRCode",
                splashColor: Colors.transparent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrCodeScannerView(),
                      ));
                },
                icon: Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  color: Colors.amber.shade900,
                  size: 35,
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "รายการยอดเติมเงินรายวัน",
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TouchableOpacity(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                            helpText: 'วันสรุปยอดเติมเงิน',
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
                          );
                          if (picked != null && picked != currentDate) {
                            setState(() {
                              currentDate = picked;
                            });
                            if (context.mounted) {
                              await context.read<AdminCubit>().getAdminTransaction(Timestamp.fromDate(currentDate));
                            }
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      BlocBuilder<AdminCubit, AdminState>(
                        builder: (context, state) {
                          if (state is AdminLoading) {
                            return CircularProgressIndicator(
                              color: Colors.amber.shade900,
                            );
                          } else if (state is AdminLoaded) {
                            return CustomText(
                              text:
                                  "฿ ${((state.transactions.where((element) => element.transactionType == "deposit").fold(0.0, (previousValue, element) => previousValue + (element.deposit ?? 0))) - (state.transactions.where((element) => element.transactionType == "withdraw").fold(0.0, (previousValue, element) => previousValue + (element.withdraw ?? 0))).floor())}",
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber.shade900,
                    ),
                  );
                } else if (state is AdminLoaded) {
                  if (state.transactions.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            "assets/images/money_transaction.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const HeightContainer(height: 10),
                        Text(
                          "ณ วันนี้ยังไม่มีการทำธุรกรรม เช่น เติมเงินหรือถอนเงิน",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.googleFont(
                            Colors.grey,
                            15,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText(
                            text: "รายการธุรกรรมการเงิน",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          const HeightContainer(height: 10),
                          ListView.separated(
                            separatorBuilder: (context, index) => const HeightContainer(height: 10),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              AdminTransactionEntity adminTransactionEntity = state.transactions[index];

                              return Row(
                                children: [
                                  Container(
                                    width: size.width * 0.25,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                                      color: adminTransactionEntity.transactionType == "deposit"
                                          ? "78A017".toColor()
                                          : "FE7144".toColor(),
                                    ),
                                    child: adminTransactionEntity.transactionType == "deposit"
                                        ? Image.asset(
                                            "assets/images/deposit.png",
                                            scale: 0.9,
                                          )
                                        : adminTransactionEntity.transactionType == "withdraw"
                                            ? Image.asset(
                                                "assets/images/withdraw.png",
                                                scale: 0.9,
                                              )
                                            : Container(),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 90,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          if (adminTransactionEntity.transactionType == "deposit") ...[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10, top: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${DateConverter.dateTimeFormat(adminTransactionEntity.date)}",
                                                    style: GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                              child: CustomText(
                                                text: adminTransactionEntity.customerName ?? "",
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  "assets/images/money.png",
                                                  scale: 1,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Text(
                                                    "฿ ${adminTransactionEntity.deposit}",
                                                    style: GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ] else if (adminTransactionEntity.transactionType == "withdraw") ...[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10, top: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${DateConverter.dateTimeFormat(adminTransactionEntity.date)}",
                                                    style: GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                              child: CustomText(
                                                text: adminTransactionEntity.customerName ?? "",
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  "assets/images/money.png",
                                                  scale: 1,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Text(
                                                    "฿ ${adminTransactionEntity.withdraw}",
                                                    style: GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
