import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/text_style.dart';
import 'package:your_choices/utilities/hex_color.dart';

class TransactionView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const TransactionView({super.key, required this.customerEntity});

  @override
  State<StatefulWidget> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: size.height * 0.54,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.customerEntity.profileUrl!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        100,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/image_picker.png",
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/image_picker.png",
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "สวัสดี ยินดีต้อนรับ",
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.customerEntity.username ??
                                        "Unknow name",
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: size.width,
                            height: size.height / 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    "#0F2027".toColor(),
                                    "#203A43".toColor(),
                                    "#2C5364".toColor(),
                                  ]),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "เงินในบัญชี : ",
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35),
                                    child: SizedBox(
                                      width: size.width,
                                      height: size.height / 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "฿ ${widget.customerEntity.balance}",
                                            style: GoogleFonts.ibmPlexSansThai(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TouchableOpacity(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.depositPage,
                              arguments: widget.customerEntity,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: size.width / 6,
                                    height: size.height / 12,
                                    decoration: BoxDecoration(
                                      color: "78A017".toColor(),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                    ),
                                    child: Image.asset(
                                        "assets/images/deposit.png"),
                                  ),
                                ),
                                Container(
                                  width: size.width / 4,
                                  height: size.height / 12,
                                  decoration: BoxDecoration(
                                    color: "34312F".toColor(),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ฝากเงิน",
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        TouchableOpacity(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.withdrawPage,
                              arguments: widget.customerEntity,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: size.width / 6,
                                    height: size.height / 12,
                                    decoration: BoxDecoration(
                                      color: "FE7144".toColor(),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                    ),
                                    child: Image.asset(
                                        "assets/images/withdraw.png"),
                                  ),
                                ),
                                Container(
                                  width: size.width / 4,
                                  height: size.height / 12,
                                  decoration: BoxDecoration(
                                    color: "34312F".toColor(),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ถอนเงิน",
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  width: double.maxFinite,
                  child: Text(
                    "ธุรกรรมต่างๆ",
                    style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.customerEntity.transaction?.isEmpty ?? false
                    ? Column(
                        children: [
                          Image.asset(
                            "assets/images/transaction.png",
                            width: 150,
                            height: 150,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ไม่มีรายการธุรกรรมใดๆ ณ ขณะนี้",
                            style: AppTextStyle.googleFont(
                              Colors.grey,
                              18,
                              FontWeight.w500,
                            ),
                          )
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemCount:
                            widget.customerEntity.transaction?.length ?? 0,
                        itemBuilder: (context, index) {
                          final date = DateConverter.dateTimeFormat(
                              widget.customerEntity.transaction![index].date);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.23,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: widget.customerEntity
                                                    .transaction![index].type ==
                                                "deposit"
                                            ? "78A017".toColor()
                                            : "FE7144".toColor(),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                      ),
                                      child: Center(
                                        child: Builder(
                                          builder: (_) {
                                            if (widget.customerEntity
                                                    .transaction![index].type ==
                                                "deposit") {
                                              return Image.asset(
                                                "assets/images/deposit.png",
                                                scale: 0.7,
                                              );
                                            } else if (widget.customerEntity
                                                    .transaction![index].type ==
                                                "withdraw") {
                                              return Image.asset(
                                                "assets/images/withdraw.png",
                                                scale: 0.8,
                                              );
                                            } else if (widget.customerEntity
                                                    .transaction![index].type ==
                                                "paid") {
                                              return Image.asset(
                                                "assets/images/rice_pic.png",
                                                scale: 0.8,
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: size.width,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (widget
                                                      .customerEntity
                                                      .transaction![index]
                                                      .type ==
                                                  "deposit") ...[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, top: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        date!,
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(
                                                    widget
                                                        .customerEntity
                                                        .transaction![index]
                                                        .name!,
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/money.png",
                                                      scale: 1,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        "฿ ${widget.customerEntity.transaction![index].deposit}",
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ] else if (widget
                                                      .customerEntity
                                                      .transaction![index]
                                                      .type ==
                                                  "withdraw") ...[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, top: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        date!,
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6),
                                                  child: Text(
                                                    widget
                                                        .customerEntity
                                                        .transaction![index]
                                                        .name!,
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/money.png",
                                                      scale: 1,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        "฿ ${widget.customerEntity.transaction![index].withdraw}",
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ] else if (widget
                                                      .customerEntity
                                                      .transaction![index]
                                                      .type ==
                                                  'paid') ...[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, top: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          widget
                                                                  .customerEntity
                                                                  .transaction?[
                                                                      index]
                                                                  .resName ??
                                                              "",
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        date!,
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6),
                                                  child: Text(
                                                    widget
                                                        .customerEntity
                                                        .transaction![index]
                                                        .menuName!,
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/money.png",
                                                      scale: 1,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        "฿ ${widget.customerEntity.transaction![index].totalPrice}",
                                                        style: GoogleFonts
                                                            .ibmPlexSansThai(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 13,
                                )
                              ],
                            ),
                          );
                        },
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
