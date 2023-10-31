// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:laywers_app/model/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/constants/ui_constants.dart';
import 'package:provider/provider.dart';

import '../widgets/spinkit.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({
    super.key,
    required this.clientModel,
    required this.firebaseUser,
    required this.advocateModel,
  });

  final ClientModel? clientModel;
  final AdvocateModel? advocateModel;
  final User firebaseUser;

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  // final ClientModel userModel;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController searchUserController = TextEditingController();

  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  late FirebaseAuthController firebaseController;

  @override
  void initState() {
    firebaseController = Get.find();
    firebaseController.showValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    // firebaseController.showValue();
    return Obx(() => Scaffold(
          backgroundColor: Colors.blue,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.1,
              automaticallyImplyLeading: false,
              leadingWidth: 90,
              centerTitle: true,

              // backgroundColor: AppColors.backgroudColor,
              title: Text(
                "Complete Profile".tr,
                style: GoogleFonts.blackOpsOne(
                  fontSize: 30.sp,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  decorationColor: Colors.black,
                  // backgroundColor: Colors.grey.shade100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/backDesign.png",
                      ),
                      fit: BoxFit.cover)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      key: _formkey,
                      child: Column(
                        children: [
                          Text(widget.clientModel != null
                              ? "Client User"
                              : "Advocate User"),
                          SizedBox(
                            height: 40.h,
                          ),
                          CupertinoButton(
                              onPressed: () {
                                // provider.changeLoading(value: false);

                                // showPhotoOption();
                                firebaseController.showPhotoOption();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [avatarShadow]),
                                child: CircleAvatar(
                                  // backgroundColor: AppColors.foregroundColor,
                                  radius: 65.r,
                                  backgroundImage:
                                      (firebaseController.image.value != null)
                                          ? FileImage(
                                              firebaseController.image.value!)
                                          : null,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 50.r,
                                        child:
                                            (firebaseController.image.value ==
                                                    null)
                                                ? Icon(
                                                    Icons.person,
                                                    color: Colors.blue,
                                                    size: 85.r,
                                                  )
                                                : null,
                                      ),
                                      Visibility(
                                          visible:
                                              firebaseController.image.value ==
                                                      null
                                                  ? true
                                                  : false,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade100),
                                            height: 20.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: Text(
                                                "Upload image".tr,
                                                style:
                                                    TextStyle(fontSize: 12.sp),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 90.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 300.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    boxShadow: [shadow],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: TextFormField(
                                      controller: fullNameController,
                                      cursorColor: Colors.black,
                                      cursorHeight: 17.sp,
                                      validator: (value) {
                                        if (!RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value!)) {
                                          return "Enter Correct Name";
                                        } else {
                                          return null;
                                        }
                                      },
                                      // controller: ,
                                      style: kTextFieldInputStyle,
                                      decoration: InputDecoration(
                                        hintText: 'Full Name'.tr,
                                        hintStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.italic),
                                        // label: Text(
                                        //   'Email',
                                        //   style: TextStyle(
                                        //       color: Colors.black, fontSize: 13.sp),
                                        // ),
                                        border: InputBorder.none,
                                        // enabledBorder: kTextFieldBorder,
                                        // focusedBorder: kTextFieldBorder
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [avatarShadow],
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40,
                                      child: Center(
                                          child: Icon(
                                        Icons.person_2_outlined,
                                        color: Colors.blue,
                                      )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 90.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 300.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    boxShadow: [shadow],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: TextField(
                                      controller: bioController,
                                      cursorColor: Colors.black,
                                      cursorHeight: 17.sp,
                                      // controller: ,
                                      style: kTextFieldInputStyle,
                                      decoration: InputDecoration(
                                        hintText: 'Bio'.tr,
                                        hintStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.italic),
                                        // label: Text(
                                        //   'Email',
                                        //   style: TextStyle(
                                        //       color: Colors.black, fontSize: 13.sp),
                                        // ),
                                        border: InputBorder.none,
                                        // enabledBorder: kTextFieldBorder,
                                        // focusedBorder: kTextFieldBorder
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [avatarShadow],
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40,
                                      child: Center(
                                          child: Icon(
                                        Icons.details_outlined,
                                        color: Colors.blue,
                                      )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          genderSelection(
                              context: context,
                              firebaseAuthController: firebaseController,
                              size: size),
                          SizedBox(
                            height: 30.h,
                          ),
                          firebaseController.isLoading.value
                              ? spinkit(color: Colors.blue)
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    // boxShadow: [shadow]
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!_formkey.currentState!.validate()) {
                                      } else {
                                        firebaseController.checkValues(
                                          userProvider: userProvider,
                                          context: context,
                                          fullName: fullNameController.text,
                                          bio: bioController.text,
                                          clientModel: widget.clientModel,
                                          advocateModel: widget.advocateModel,
                                        );

                                        // log(UserProvider.clientModel.email
                                        //     .toString());

                                        // checkValues(
                                        //     provider: provider,
                                        //     userModelProvider: userModelProvider);
                                      }
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 35.w)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    child: Text(
                                      "Submit".tr,
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ),
                                )
                        ],
                      ))),
            ),
          ),
        ));
  }

  Widget genderSelection(
      {required Size size,
      required BuildContext context,
      required FirebaseAuthController firebaseAuthController}) {
    return GetBuilder(
      init: Get.find<FirebaseAuthController>(),
      builder: (firebasController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Radio.adaptive(
                      value: firebaseAuthController.genderTypes[0],
                      groupValue: firebaseAuthController.selectGender.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changegender(gender: onChanged!);
                        log(firebasController.selectGender.value);
                      })),
                  Text(
                    "Male".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                children: [
                  Radio.adaptive(
                      value: firebaseAuthController.genderTypes[1],
                      groupValue: firebaseAuthController.selectGender.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changegender(gender: onChanged!);
                        log(firebasController.selectGender.value);
                      })),
                  Text(
                    "Female".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
