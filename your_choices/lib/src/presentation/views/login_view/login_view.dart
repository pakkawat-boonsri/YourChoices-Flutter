import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_main_view/customer_main_view.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/show_flutter_toast.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../utilities/loading_dialog.dart';
import '../vendor_side/vendor_main_view/vendor_main_view.dart';

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

  // bool isClick = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialLoading) {
          loadingDialog(context);
        }
        if (credentialState is CredentialSuccess) {
          Navigator.of(context).pop();
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialState is CredentialFailure) {
          showFlutterToast("Invalid Email and Password");
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                if (state.type == "restaurant") {
                  return VendorMainView(uid: state.uid);
                } else {
                  return CustomerMainView(uid: state.uid);
                }
              } else {
                return bodySelection(size, context);
              }
            },
          );
        }
        return bodySelection(size, context);
      },
    );
  }

  Scaffold bodySelection(Size size, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // reverse: isClick,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const HeaderText(),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                // onTap: () {
                                //   setState(() {
                                //     isClick = true;
                                //   });
                                // },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: "i.e you@example.com",
                                  labelText: "อีเมล",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  floatingLabelStyle: AppTextStyle.googleFont(
                                    Colors.grey,
                                    16,
                                    FontWeight.w500,
                                  ),
                                  suffixIcon: email.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            email.clear();
                                            setState(() {});
                                          },
                                        )
                                      : const SizedBox(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
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
                                    return "โปรดกรอกอีเมลของท่าน";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                // onTap: () {
                                //   setState(() {
                                //     isClick = true;
                                //   });
                                // },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                obscureText: true,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  floatingLabelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText: "yourpassword1234",
                                  labelText: "รหัสผ่าน",
                                  suffixIcon: password.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            password.clear();
                                            setState(() {});
                                          },
                                        )
                                      : const SizedBox(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amber.shade900,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
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
                                    return "โปรดกรอกรหัสผ่านของท่าน";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // log("${_formkey.currentState!.validate()}");
                          if (_formkey.currentState!.validate()) {
                            await BlocProvider.of<CredentialCubit>(context)
                                .signInUser(
                                  email: email.text,
                                  password: password.text,
                                )
                                .then((value) => _clear());
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
                          "เข้าสู่ระบบ",
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

  _clear() {
    setState(() {
      email.clear();
      password.clear();
    });
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ยังไม่มีแอ็กเคานต์? ",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 16,
              color: "130B71".toColor(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TouchableOpacity(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                PageConst.registerPage,
                (route) => false,
              );
            },
            child: Text(
              "ลงทะเบียนใช้งาน",
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "สวัสดี",
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ลงชื่อเข้าใช้บัญชีของคุณ",
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
