import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/views/register_view/register_view.dart';
import 'package:your_choices/utilities/hex_color.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: isClick,
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
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                onTap: () {
                                  setState(() {
                                    isClick = true;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  labelText: "Email",
                                  suffixIcon: email.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            password.clear();
                                            setState(() {});
                                          },
                                        )
                                      : const SizedBox(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your Email.";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onTap: () {
                                  setState(() {
                                    isClick = true;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                obscureText: true,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  labelText: "Password",
                                  suffixIcon: password.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            password.clear();
                                            setState(() {});
                                          },
                                        )
                                      : const SizedBox(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your password.";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            BlocProvider.of<CredentialCubit>(context)
                                .signInCustomer(
                              email: email.text,
                              password: password.text,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.amber.shade900),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 100.0),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      ),
                      const SizedBox(
                        height: 40.0,
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
                "Don't have an account yet? ",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  color: "130B71".toColor(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                      result: (route) => false);
                },
                child: Text(
                  "Sign up",
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

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 35),
      child: Column(
        children: [
          SizedBox(
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
