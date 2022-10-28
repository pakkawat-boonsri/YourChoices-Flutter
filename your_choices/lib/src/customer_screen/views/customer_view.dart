import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/src/customer_screen/view_model/customer_view_model.dart';
import 'package:your_choices/utilities/hex_color.dart';

class CustomerView extends StatelessWidget {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: size.height / 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                FutureBuilder(
                  future: context.read<CustomerViewModel>().getUserData(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      child: Image.file(
                                        File(snapshot.data!.imgAvatar),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        snapshot.data!.username,
                                        style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
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
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding:
                                            const EdgeInsets.only(right: 35),
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
                                                snapshot.data!.balance
                                                    .toString(),
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
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
                        );
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                    }
                    return const SizedBox();
                  },
                ),
                Row(
                  children: [
                    Padding(
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
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Image.asset("assets/images/deposit.png"),
                            ),
                          ),
                          Container(
                            width: size.width / 4,
                            height: size.height / 12,
                            decoration: BoxDecoration(
                              color: "34312F".toColor(),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
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
                    Padding(
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
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Image.asset("assets/images/withdraw.png"),
                            ),
                          ),
                          Container(
                            width: size.width / 4,
                            height: size.height / 12,
                            decoration: BoxDecoration(
                              color: "34312F".toColor(),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
