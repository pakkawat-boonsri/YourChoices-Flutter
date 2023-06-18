// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/blocs/utilities_bloc/auth/auth_cubit.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';

class ProfileView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const ProfileView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? imageFile;

  Future pickImageFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.camera);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future optionToTakeImage(BuildContext context) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    "คลังรูปภาพ",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromGallery = await pickImageFromGallery();

                    imageFile = imageFromGallery;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 1,
                  color: Colors.black,
                ),
                ListTile(
                  title: Text(
                    "กล้อง",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromCamera = await pickImageFromCamera();

                    imageFile = imageFromCamera;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showModelSheet(BuildContext context) async {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return ShowModelSheetContent(
          customerEntity: widget.customerEntity,
          optionToTakeImage: optionToTakeImage,
          profileFile: imageFile,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "หน้าโปรไฟล์",
          style: AppTextStyle.googleFont(
            Colors.black,
            23,
            FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.customerEntity.profileUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            100,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/images/image_picker.png",
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/image_picker.png",
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.customerEntity.username}",
                        style: AppTextStyle.googleFont(
                          Colors.white,
                          20,
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TouchableOpacity(
                        onTap: () {
                          showModelSheet(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit,
                              color: "FF602E".toColor(),
                              size: 22,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "แก้ไขโปรไฟล์",
                              style: AppTextStyle.googleFont(
                                Colors.white,
                                16,
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Divider(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "รายการเพิ่มเติม",
              style: AppTextStyle.googleFont(
                Colors.white,
                22,
                FontWeight.w600,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.favoritePage,
                    arguments: widget.customerEntity,
                  );
                },
                leading: Icon(
                  CupertinoIcons.heart,
                  color: Colors.amber.shade900,
                  size: 32,
                ),
                title: Text(
                  "ร้านโปรดที่บันทักไว้",
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    18,
                    FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
            const Spacer(),
            TouchableOpacity(
              onTap: () {
                loadingDialog(context);
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  context.read<AuthCubit>().loggingOut().then(
                        (value) => Navigator.pop(context),
                      );
                });
              },
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "ออกจากระบบ",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    20,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowModelSheetContent extends StatefulWidget {
  final CustomerEntity customerEntity;
  final Future Function(BuildContext context) optionToTakeImage;
  final File? profileFile;
  const ShowModelSheetContent({
    Key? key,
    required this.customerEntity,
    required this.optionToTakeImage,
    this.profileFile,
  }) : super(key: key);

  @override
  State<ShowModelSheetContent> createState() => _ShowModelSheetContentState();
}

class _ShowModelSheetContentState extends State<ShowModelSheetContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController userNameController;

  @override
  void initState() {
    userNameController = TextEditingController(text: widget.customerEntity.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBar(
          toolbarHeight: 64,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          title: Text(
            "แก้ไขโปรไฟล์",
            style: AppTextStyle.googleFont(
              Colors.black,
              24,
              FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TouchableOpacity(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: "B44121".toColor(),
                  radius: 20,
                  child: Image.asset(
                    "assets/images/Xcross.png",
                    scale: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
        StatefulBuilder(
          builder: (context, setState) => TouchableOpacity(
            onTap: () async {
              await widget.optionToTakeImage(context);
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      widget.profileFile == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 58,
                                backgroundColor: Colors.transparent,
                                backgroundImage: widget.customerEntity.profileUrl == null
                                    ? const AssetImage(
                                        "assets/images/image_picker.png",
                                      ) as ImageProvider
                                    : CachedNetworkImageProvider(
                                        widget.customerEntity.profileUrl!,
                                      ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 58,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(widget.profileFile!),
                              ),
                            ),
                      Positioned(
                        left: 95,
                        top: 95,
                        child: Container(
                          width: 40,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber.shade900,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "เลือกรูปโปรไฟล์",
                  style: AppTextStyle.googleFont(
                    "FF602E".toColor(),
                    15,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "ชื่อผู้ใช้",
                style: AppTextStyle.googleFont(
                  Colors.black,
                  20,
                  FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "ระบุชื่อผู้ใช้เพื่อสำหรับแสดงผล",
                style: AppTextStyle.googleFont(
                  Colors.black54,
                  16,
                  FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                // MediaQuery.of(context).viewInsets.bottom
                child: TextFormField(
                  controller: userNameController,
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    16,
                    FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "โปรดกรอกชื่อผู้ใช้ของท่าน";
                    }
                    return null;
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10,
                    ),
                    errorStyle: AppTextStyle.googleFont(
                      Colors.red,
                      16,
                      FontWeight.w500,
                    ),
                    isDense: true,
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                      ),
                    ),
                    hintText: "ชื่อผู้ใช้",
                    hintStyle: AppTextStyle.googleFont(
                      Colors.grey,
                      18,
                      FontWeight.w500,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: TouchableOpacity(
                onTap: () async {
                  // final navigator = Navigator.of(context, rootNavigator: true);
                  loadingDialog(context);
                  BlocProvider.of<CustomerCubit>(context).updateCustomer(
                    customerEntity: widget.customerEntity.copyWith(
                      username: userNameController.text,
                      profileUrl: widget.profileFile == null
                          ? widget.customerEntity.profileUrl
                          : await di.sl<UploadImageToStorageUseCase>().call(widget.profileFile!, "profileImage"),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2)).then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade900,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "อัพเดทข้อมูลผู้ใช้",
                    style: AppTextStyle.googleFont(
                      Colors.white,
                      18,
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
