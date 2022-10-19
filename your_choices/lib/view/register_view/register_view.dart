import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/utilities/reuseable_widget.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _regisKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final comfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 95),
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          HeaderWelcome(size: size),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _regisKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Username",
                                      labelText: "Username",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/images/ic_launcher_round.png",
                    scale: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWelcome extends StatelessWidget {
  const HeaderWelcome({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90, left: 35),
      child: SizedBox(
        width: size.width,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign up for your account",
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Stack(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          boxShadow(),
                        ]),
                    child: Image.asset("assets/images/inage_picker.png",
                        scale: 1.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
