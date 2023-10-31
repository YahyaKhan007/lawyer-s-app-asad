// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/advocate_model.dart';
import 'package:laywers_app/model/client_model.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:provider/provider.dart';

import '../constants/ui_constants.dart';
import '../widgets/spinkit.dart';

class Login extends StatefulWidget {
  // final ClientModel clientModel;
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();

  FocusNode focus1 = FocusNode();

  FocusNode focus2 = FocusNode();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  late AdvocateProvider advocateProvider;
  late FirebaseAuthController firebaseController;
  // final _controller = ActionSliderController();

  @override
  void initState() {
    firebaseController = Get.find<FirebaseAuthController>();
    super.initState();
    Future.delayed(const Duration(seconds: 2),
        () => firebaseController.isLoading.value = false);
    advocateProvider = Provider.of<AdvocateProvider>(context, listen: false);

    // Call the init method to fetch all users
    advocateProvider.getAllUsers();
    advocateProvider.getAllClientUsers();
    advocateProvider.geAdminModel();

    log("init state called");
  }

  @override
  Widget build(BuildContext context) {
    log("Advocate users are ${advocateProvider.users.length}");
    log("Client users are ${advocateProvider.clientUsers.length}");
    Size size = MediaQuery.of(context).size;
    UserProvider? userProvider =
        Provider.of<UserProvider>(context, listen: true);
    // Loading loading = Provider.of<Loading>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.blue,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Dont have any account".tr,
              style: TextStyle(fontSize: 11.sp),
            ),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () {
                Get.off(() => const Signup(),
                    transition: Transition.zoom,
                    duration: const Duration(milliseconds: 800));
              },
              child: Text(
                "Signup here".tr,
                style: TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
              ),
            )
          ]),
          SizedBox(
            height: 15.h,
          )
        ],
      ),
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
      body: GetBuilder<FirebaseAuthController>(
          init: FirebaseAuthController(),
          builder: (firebaseController) => Container(
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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Text("EmoChat",
                          //     style: GoogleFonts.blackOpsOne(
                          //         textStyle:
                          //             Theme.of(context).textTheme.bodyMedium,
                          //         decorationColor: Colors.black,
                          //         backgroundColor: Colors.grey.shade100,
                          //         color: Colors.blue,
                          //         fontSize: 55.sp)
                          // ),
                          Text("Welcome Back !",
                              style: GoogleFonts.blackOpsOne(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  decorationColor: Colors.black,
                                  // backgroundColor: Colors.blue.shade100,
                                  color: Colors.white,
                                  fontSize: 22.sp)),
                          Text("Login to your account".tr,
                              style: GoogleFonts.blackOpsOne(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  decorationColor: Colors.black,
                                  // backgroundColor: Colors.blue.shade100,
                                  color: Colors.black,
                                  fontSize: 12.sp)),
                          SizedBox(
                            height: 45.h,
                          ),
                          // ^ email Option
                          loginOption(
                              context: context,
                              controller: emailController,
                              title: "Email".tr),

                          // ^ password Option
                          loginOption(
                              context: context,
                              controller: passController,
                              title: "Password".tr),

                          // ~  Select Account Type
                          genderSelection(
                              context: context,
                              firebaseAuthController: firebaseController,
                              size: size),

                          // ~ Login button

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
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                      ),
                                      onPressed: () async {
                                        focus1.unfocus();
                                        focus2.unfocus();
                                        if (!_formkey.currentState!
                                            .validate()) {
                                        } else {
                                          if (firebaseController
                                                  .selectAccountType.value ==
                                              'Advocate') {
                                            AdvocateModel? advocateModel;
                                            for (var user
                                                in advocateProvider.users) {
                                              if (emailController.text ==
                                                  user.email) {
                                                // ^ Advocate Login
                                                log("There is a match");
                                                advocateModel = user;
                                              }
                                            }
                                            if (advocateModel != null) {
                                              firebaseController.loginUser(
                                                  email: emailController.text,
                                                  password: passController.text,
                                                  userProvider: userProvider,
                                                  type: firebaseController
                                                      .selectAccountType.value);
                                            } else {
                                              Get.snackbar("Advocate Not Found",
                                                  "No Lawyer User Founds with this email");
                                            }
                                          }

                                          // ^Client Login

                                          else if (firebaseController
                                                  .selectAccountType.value ==
                                              'Client User') {
                                            ClientModel? clientModel;
                                            for (var user in advocateProvider
                                                .clientUsers) {
                                              if (emailController.text ==
                                                  user.email) {
                                                log("There is a match");
                                                clientModel = user;
                                              }
                                            }
                                            if (clientModel != null) {
                                              firebaseController.loginUser(
                                                  email: emailController.text,
                                                  password: passController.text,
                                                  userProvider: userProvider,
                                                  type: firebaseController
                                                      .selectAccountType.value);
                                            } else {
                                              Get.snackbar("Client Not Found",
                                                  "No Client User Founds with this email");
                                            }
                                          } else if (firebaseController
                                                  .selectAccountType.value ==
                                              'Admin') {
                                            try {
                                              if (emailController.text ==
                                                      'admin@gmail.com' &&
                                                  passController.text ==
                                                      'admin1234') {
                                                firebaseController
                                                    .isLoading.value = true;

                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: 'admin@gmail.com'
                                                            .toString(),
                                                        password: "admin1234"
                                                            .toString());

                                                User? currentUser = FirebaseAuth
                                                    .instance.currentUser;

                                                if (currentUser != null) {
                                                  Get.to(() => AdminHomePage(
                                                      adminModel:
                                                          advocateProvider
                                                              .adminModel!));
                                                }
                                              }
                                            } catch (e) {
                                              firebaseController
                                                  .isLoading.value = false;

                                              Get.showSnackbar(
                                                GetSnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  message:
                                                      'Resolve the Issue'.tr,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Login".tr,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )),
              )),
    );
  }

  Widget loginOption(
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
                  onTap: () {
                    setState(() {});
                  },
                  obscureText: title == 'Email'
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
                    suffixIcon: title != 'Email'
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
                    title == 'Email'
                        ? Icons.person_2_outlined
                        : title == 'Password'
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
                      value: firebaseAuthController.accountTypes[2],
                      groupValue:
                          firebaseAuthController.selectAccountType.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changeAccountType(
                            type: onChanged!);
                        log(firebasController.selectAccountType.value);
                      })),
                  Text(
                    "Admin",
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
                      value: firebaseAuthController.accountTypes[0],
                      groupValue:
                          firebaseAuthController.selectAccountType.value,
                      onChanged: ((onChanged) {
                        firebaseAuthController.changeAccountType(
                            type: onChanged!);
                        log(firebasController.selectAccountType.value);
                      })),
                  Text(
                    "Client User",
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
                    "Advocate",
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
