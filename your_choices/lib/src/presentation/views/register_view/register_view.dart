import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/main_view/main_view.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/reuseable_widget.dart';

import '../../../../utilities/show_flutter_toast.dart';
import '../../../domain/entities/customer/customer_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/credential/credential_cubit.dart';

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

  String selectingType = 'customer';

  File? imageFile;

  Future pickImageFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return null;
      } else {
        imageFile = File(file.path);
        setState(() {});
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  bool isClick = false;
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
      if (credentialState is CredentialSuccess) {
        BlocProvider.of<AuthCubit>(context).loggedIn();
      }
      if (credentialState is CredentialFailure) {
        showFlutterToast("Invalid Email and Password");
      }
    }, builder: (context, credentialState) {
      if (credentialState is CredentialSuccess) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return MainView(uid: state.uid);
            } else {
              return bodySelection(size, context);
            }
          },
        );
      }
      return bodySelection(size, context);
    });
  }

  Scaffold bodySelection(Size size, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: isClick,
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
                        HeaderWelcome(
                          size: size,
                          file: imageFile,
                          pickImageFromGallery: pickImageFromGallery,
                        ),
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
                                    setState(() {
                                      isClick = true;
                                    });
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
                                    setState(() {
                                      isClick = true;
                                    });
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
                                    setState(() {
                                      isClick = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: password,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: isObscurePassword,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    labelText: "Password",
                                    suffixIcon: password.text.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  isObscurePassword =
                                                      !isObscurePassword;
                                                }),
                                                icon: isObscurePassword
                                                    ? const Icon(
                                                        Icons.visibility)
                                                    : const Icon(
                                                        Icons.visibility_off),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  password.clear();
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons.clear),
                                              ),
                                            ],
                                          )
                                        : null,
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
                                    setState(() {
                                      isClick = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: confirmPassword,
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  obscureText: isObscureConfirmPassword,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Confirm password",
                                    labelText: "Confirm password",
                                    suffixIcon: confirmPassword.text.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isObscureConfirmPassword =
                                                        !isObscureConfirmPassword;
                                                  });
                                                },
                                                icon: isObscureConfirmPassword
                                                    ? const Icon(
                                                        Icons.visibility)
                                                    : const Icon(
                                                        Icons.visibility_off),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  confirmPassword.clear();
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons.clear),
                                              ),
                                            ],
                                          )
                                        : null,
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
                                          groupValue: selectingType,
                                          onChanged: ((value) {
                                            log(value.toString());
                                            setState(() {
                                              selectingType = value.toString();
                                            });
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
                                              groupValue: selectingType,
                                              onChanged: ((value) {
                                                log(value.toString());
                                                setState(() {
                                                  selectingType =
                                                      value.toString();
                                                });
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
                          onPressed: () async {
                            final result = _regisKey.currentState!.validate();
                            if (result) {
                              BlocProvider.of<CredentialCubit>(context)
                                  .signUpCustomer(
                                customerEntity: CustomerEntity(
                                    email: email.text,
                                    password: password.text,
                                    username: username.text,
                                    transaction: const [],
                                    type: selectingType,
                                    balance: 0,
                                    imageFile: imageFile),
                              );
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
  final File? file;
  final VoidCallback pickImageFromGallery;
  const HeaderWelcome({
    Key? key,
    required this.size,
    required this.pickImageFromGallery,
    required this.file,
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
                pickImageFromGallery();
              }),
              child: file != null
                  ? Container(
                      height: 126,
                      width: 126,
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          file!,
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
                        const Positioned(
                          right: 18,
                          bottom: 20,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: Colors.black,
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
