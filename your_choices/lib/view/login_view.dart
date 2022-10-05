import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/view/register_view.dart';

import '../constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 95),
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100, left: 35),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // color: Colors.redAccent,
                              width: double.maxFinite,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "HELLO",
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Sign into your account.",
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: SizedBox(
                          child: Column(
                            children: [
                              TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: "name.sur@ku.th",
                                  labelText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.mail_outline,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                obscureText: true,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  labelText: "Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.amber.shade900),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 100.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(registerRoutes,
                                        (Route<dynamic> route) => false),
                              text: "Sign in",
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset("assets/images/ic_launcher_round.png"),
            ],
          ),
        ),
      ),
    );
  }
}
