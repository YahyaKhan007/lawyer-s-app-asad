// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/services/loading_provider.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/complete_profile.dart/login.dart';
import 'package:laywers_app/view/constants/ui_constants.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:provider/provider.dart';

import '../widgets/spinkit.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();

  FocusNode focus1 = FocusNode();

  FocusNode focus2 = FocusNode();

  FocusNode focus3 = FocusNode();

  TextEditingController signupEmailController = TextEditingController();

  TextEditingController signupPasswordController = TextEditingController();

  TextEditingController signupConfirmPasswordController =
      TextEditingController();
  final _controller = ActionSliderController();

  @override
  void initState() {
    Get.find<FirebaseAuthController>().whereToGo.value = 'signup';
    super.initState();
  }

  // var firebaseController = Get.find<FirebaseAuthController>();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    Loading loading = Provider.of<Loading>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return GetBuilder<FirebaseAuthController>(
      init: FirebaseAuthController(),
      builder: (firebaseController) => Scaffold(
          bottomSheet: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Already have an account?".tr,
                  style: TextStyle(fontSize: 11.sp),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    Get.off(() => Login(),
                        transition: Transition.zoom,
                        duration: const Duration(milliseconds: 800));
                  },
                  child: Text(
                    "Login here".tr,
                    style:
                        TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
                  ),
                )
              ]),
              SizedBox(
                height: 15.h,
              )
            ],
          ),
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
                "Lawyer's App".tr,
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
          body: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/backDesign.png",
                    ),
                    fit: BoxFit.cover)),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Welcome Back !".tr,
                      style: GoogleFonts.blackOpsOne(
                        fontSize: 22.sp,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      "Create an acoount".tr,
                      style: GoogleFonts.blackOpsOne(
                        fontSize: 12.sp,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white70,
                      ),
                    ),
                    signupOption(
                        controller: signupEmailController,
                        title: 'Email'.tr,
                        context: context),

                    signupOption(
                        controller: signupPasswordController,
                        title: 'Password'.tr,
                        context: context),
                    signupOption(
                        controller: signupConfirmPasswordController,
                        title: 'Confirm Password'.tr,
                        context: context),

                    const SizedBox(
                      height: 0,
                    ),

                    accountTypeSelection(
                        context: context,
                        firebaseAuthController: firebaseController,
                        size: size),

                    const SizedBox(
                      height: 5,
                    ),

                    // ~ ----------------------------------------
                    // ~ ----------------------------------------

                    Obx(
                      () => firebaseController.isLoading.value
                          ? spinkit(color: Colors.blue)
                          : Container(
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(25),
                                // boxShadow: [shadow],
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 35)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                onPressed: () async {
                                  focus1.unfocus();
                                  focus2.unfocus();
                                  focus3.unfocus();
                                  log("Trying to Signup");
                                  if (!_formkey.currentState!.validate()) {
                                  } else {
                                    if (signupPasswordController.text !=
                                        signupConfirmPasswordController.text) {
                                      Get.snackbar("Password Miss Matched".tr,
                                          "Both Passwords should match".tr,
                                          colorText: Colors.black, barBlur: 15);
                                    } else {
                                      log("went for  Signup");
                                      firebaseController.isLoading.value = true;

                                      firebaseController.signupUser(
                                          userProvider: userProvider,
                                          email: signupEmailController.text
                                              .toLowerCase(),
                                          password: signupPasswordController
                                              .text
                                              .toString(),
                                          accountType: firebaseController
                                              .selectAccountType.value);
                                    }
                                  }
                                },
                                child: Text(
                                  "Signup".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    // loading.loading
                    //     ? spinkit(color: Colors.blue)
                    //     : Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //         child: ActionSlider.custom(
                    //           sliderBehavior: SliderBehavior.move,
                    //           width: size.width,
                    //           controller: _controller,
                    //           height: 50.0,
                    //           toggleWidth: 50.0,
                    //           toggleMargin: EdgeInsets.zero,
                    //           backgroundColor: Colors.green,
                    //           foregroundChild: DecoratedBox(
                    //               decoration: BoxDecoration(
                    //                   color: Colors.blue,
                    //                   borderRadius: BorderRadius.circular(50)),
                    //               child: const Icon(Icons.login,
                    //                   color: Colors.white)),
                    //           foregroundBuilder: (context, state, child) =>
                    //               child!,
                    //           outerBackgroundBuilder: (context, state, child) =>
                    //               Container(
                    //             margin: EdgeInsets.zero,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(50),
                    //               color: Color.lerp(Colors.blue.shade100,
                    //                   Colors.blue, state.position),
                    //             ),
                    //             child: const Center(
                    //               child: Text(
                    //                 "Swipe Right For Admin Signup",
                    //               ),
                    //             ),
                    //           ),
                    //           backgroundBorderRadius:
                    //               BorderRadius.circular(10.0),
                    //           action: (controller) {
                    //             firebaseController.adminSignup(
                    //                 email: signupEmailController.text,
                    //                 password: signupPasswordController.text,
                    //                 loading: loading,
                    //                 confirmPassword:
                    //                     signupConfirmPasswordController.text);
                    //           },
                    //         ),
                    //       )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget signupOption(
      {required String title,
      required TextEditingController controller,
      required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox(
        height: 90.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              decoration: BoxDecoration(
                boxShadow: [shadow],
                color: Colors.white70,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: TextFormField(
                  obscureText: title == 'Email'.tr
                      ? false
                      : Get.find<FirebaseAuthController>().showPassword.value,
                  controller: controller,
                  cursorColor: Colors.black,
                  cursorHeight: 17.sp,
                  // validator: title == 'Email'
                  //     ? (value) {
                  //         if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                  //           return "Enter Correct Name";
                  //         } else {
                  //           return null;
                  //         }
                  //       }
                  //     : null,
                  // controller: ,
                  style: kTextFieldInputStyle,

                  decoration: InputDecoration(
                    suffixIcon: title != 'Email'.tr
                        ? GestureDetector(
                            onTap: () {
                              var controller =
                                  Get.find<FirebaseAuthController>();

                              controller.changeShowPassword(
                                  condition: !controller.showPassword.value);
                              log("presses");
                            },
                            child: const Icon(Icons.remove_red_eye),
                          )
                        : null,
                    hintText: title,
                    hintStyle:
                        TextStyle(fontSize: 12.sp, fontStyle: FontStyle.italic),
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
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 40,
                  child: Center(
                      child: Icon(
                    title == 'Email'.tr
                        ? Icons.person_2_outlined
                        : title == 'Password'.tr
                            ? Icons.password_sharp
                            : Icons.password_sharp,
                    color: Colors.blue,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget accountTypeSelection(
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
                      value: firebaseAuthController.accountTypes[0],
                      groupValue:
                          firebaseAuthController.selectAccountType.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changeAccountType(
                            type: onChanged!);
                        log(firebasController.selectAccountType.value);
                      })),
                  Text(
                    "Client User".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                children: [
                  Radio.adaptive(
                      value: firebaseAuthController.accountTypes[1],
                      groupValue:
                          firebaseAuthController.selectAccountType.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changeAccountType(
                            type: onChanged!);
                        log(firebasController.selectAccountType.value);
                      })),
                  Text(
                    "Advocate".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
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
