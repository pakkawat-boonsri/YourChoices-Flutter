import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/reuseable_widget.dart';
import 'package:your_choices/view/login_view/login_view.dart';
import 'package:your_choices/view_model/register_view_model/register_view_model.dart';

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
  void initState() {
    super.initState();
    // Timer(
    //   const Duration(seconds: 2),
    //   () {
    //     context.watch<RegisterViewModel>().isLoading = true;
    //   },
    // );
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    comfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                          height: 20,
                        ),
                        Form(
                          key: _regisKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                TextFormField(
                                  onTap: context
                                      .read<RegisterViewModel>()
                                      .setIsClick(true),
                                  controller: username,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    labelText: "Username",
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
                                      return "Please enter your Username.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onTap: context
                                      .read<RegisterViewModel>()
                                      .setIsClick(true),
                                  controller: email,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    labelText: "Email",
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
                                      return "Please enter your Email.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onTap: context
                                      .read<RegisterViewModel>()
                                      .setIsClick(true),
                                  controller: password,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    labelText: "Password",
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
                                  onTap: context
                                      .read<RegisterViewModel>()
                                      .setIsClick(true),
                                  controller: comfirmPassword,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Confirm password",
                                    labelText: "Confirm password",
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
                                    } else if (password != comfirmPassword) {
                                      return "Your comfirm password is not correct!.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<RegisterViewModel>(
                                    builder: (context, viewModel, _) {
                                  return CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      "Customer",
                                      style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 15,
                                      ),
                                    ),
                                    value: viewModel.getCustomerCheck,
                                    onChanged: (value) {
                                      viewModel.setCustomerCheck(value!);
                                    },
                                  );
                                }),
                                Consumer<RegisterViewModel>(
                                  builder: (context, viewModel, _) {
                                    return CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        "Retaurant",
                                        style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 15,
                                        ),
                                      ),
                                      value: viewModel.getRestaurantCheck,
                                      onChanged: (value) {
                                        viewModel.setRestaurantCheck(value!);
                                      },
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_regisKey.currentState!.validate()) {}
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber.shade900),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(
                                          horizontal: 100.0),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Sign In",
                                    style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
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
