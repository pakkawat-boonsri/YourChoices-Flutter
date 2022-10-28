import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/reuseable_widget.dart';
import 'package:your_choices/src/login_screen/views/login_view.dart';
import 'package:your_choices/src/register_screen/view_model/register_view_model.dart';

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
  final confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: context.watch<RegisterViewModel>().getIsClick,
            child: Stack(
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
                          height: 5,
                        ),
                        Form(
                          key: _regisKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                TextFormField(
                                  onTap: () {
                                    context
                                        .read<RegisterViewModel>()
                                        .setIsClick(true);
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: username,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    labelText: "Username",
                                    suffixIcon: username.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              username.clear();
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : null,
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
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Username.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onTap: () {
                                    context
                                        .read<RegisterViewModel>()
                                        .setIsClick(true);
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: email,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    labelText: "Email",
                                    suffixIcon: email.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              email.clear();
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : null,
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
                                    String pattern = r'\w+@\w+\.\w+';
                                    if (!RegExp(pattern).hasMatch(value)) {
                                      return 'Invalid E-mail Address format.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onTap: () {
                                    context
                                        .read<RegisterViewModel>()
                                        .setIsClick(true);
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: password,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: context
                                      .watch<RegisterViewModel>()
                                      .getObscureText,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    labelText: "Password",
                                    suffixIcon: password.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              password.clear();
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : null,
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
                                      return "Please enter your Password.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onTap: () {
                                    context
                                        .read<RegisterViewModel>()
                                        .setIsClick(true);
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: confirmPassword,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Confirm password",
                                    labelText: "Confirm password",
                                    suffixIcon: confirmPassword.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              confirmPassword.clear();
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : null,
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
                                      return "Please enter your Password.";
                                    } else if (password.text !=
                                        confirmPassword.text) {
                                      return "Your confirm password is not correct!.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: "customer",
                                          groupValue: context
                                              .watch<RegisterViewModel>()
                                              .getSelectedType,
                                          onChanged: ((value) {
                                            log(value.toString());
                                            context
                                                .read<RegisterViewModel>()
                                                .setSelectedType(value);
                                          }),
                                        ),
                                        const Text("Customer")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: "restaurant",
                                              groupValue: context
                                                  .watch<RegisterViewModel>()
                                                  .getSelectedType,
                                              onChanged: ((value) {
                                                log(value.toString());
                                                context
                                                    .read<RegisterViewModel>()
                                                    .setSelectedType(value);
                                              }),
                                            ),
                                          ],
                                        ),
                                        const Text("Restaurant"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final result = _regisKey.currentState!.validate();
                            log(result.toString());
                            if (result) {
                              log("optap");
                              String type = context
                                  .read<RegisterViewModel>()
                                  .getSelectedType;
                              context
                                  .read<RegisterViewModel>()
                                  .createUserWithEmailAndpassword(
                                      context,
                                      username.text,
                                      email.text,
                                      password.text,
                                      type);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                  (route) => false);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.amber.shade900),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 100.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichTextNavigatorText(
                          size: size,
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
          ),
        ),
      ),
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
                  color: "130B71".toColor(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false);
                },
                child: Text(
                  "Sign In",
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
            GestureDetector(
              onTap: (() {
                context.read<RegisterViewModel>().pickImageFromGallery();
              }),
              child: context.watch<RegisterViewModel>().imageFile != null
                  ? Container(
                      height: 126,
                      width: 126,
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          context.watch<RegisterViewModel>().imageFile!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          width: MediaQuery.of(context).size.width / 3 - 20,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                boxShadow(),
                              ]),
                          child: Image.asset("assets/images/image_picker.png",
                              scale: 1.1),
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
