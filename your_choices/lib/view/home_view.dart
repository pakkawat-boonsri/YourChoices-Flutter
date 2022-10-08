import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  NetworkImage img = const NetworkImage(
      "https://team.mithesports.com/static/profiles/NoctisAK47-ceb7c4dfd3c7a223cea238e666499958.jpg");
  final balance = 2347.23;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height / 2.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: img,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Dee NoctisAK47",
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 130, top: 3),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 4,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.shopping_cart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 30,
              top: 90,
              child: Container(
                width: size.width - 60,
                height: size.width / 2 - 20,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF2C5364),
                        Color(0xFF203A43),
                        Color(0xFF0F2027)
                      ]),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Text(
                        "Total Balance :",
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 130),
                      child: Row(
                        children: [
                          const Image(
                            width: 40,
                            height: 40,
                            color: Colors.white,
                            image: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/32/32632.png"),
                          ),
                          Text(
                            balance.toString(),
                            style: GoogleFonts.ibmPlexSansThai(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 290,
              left: 40,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        width: size.width / 3 + 10,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34312f),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Deposit",
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        width: size.width / 3 + 10,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34312f),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            "Withdraw",
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Container(
                      width: size.width / 6 - 10,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Color(0xFF78A017),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/deposit.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 162,
                    child: Container(
                      width: size.width / 6 - 10,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFE7144),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/withdraw.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
