import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/utilities/reuseable_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

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
                    children: [
                      const HeaderText(),
                      const SizedBox(
                        height: 25,
                      ),
                      EmailPasswordTextFormField(
                          email: email, password: password),
                      const SizedBox(
                        height: 20,
                      ),
                      const SignInButton(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const DividerWithText(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: size.width / 2 + 20,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/google_logo.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue with Google",
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF130B71),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RichTextNavigatorText(size: size),
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

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            indent: 40,
            endIndent: 20,
            color: Colors.black,
            thickness: 1,
          ),
        ),
        Text(
          "Or continue with",
          style: GoogleFonts.ibmPlexSansThai(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Expanded(
          child: Divider(
            thickness: 1,
            indent: 20,
            endIndent: 40,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class RichTextNavigatorText extends StatelessWidget {
  const RichTextNavigatorText({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      width: size.width,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Already have an account? ",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Sign in",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.amber.shade900),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 100.0),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        "Sign In",
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}

class EmailPasswordTextFormField extends StatelessWidget {
  const EmailPasswordTextFormField({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: SizedBox(
        child: Column(
          children: [
            reuseableTextFormField(email, false, "Email", Icons.mail_outline),
            const SizedBox(
              height: 20,
            ),
            reuseableTextFormField(
                password, true, "Password", Icons.lock_outline)
          ],
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 35),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // color: Colors.redAccent,
            width: double.maxFinite,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "HELLO",
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 48, fontWeight: FontWeight.bold),
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
    );
  }
}
