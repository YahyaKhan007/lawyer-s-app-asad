import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

class EditAdvocate extends StatefulWidget {
  final AdvocateModel advocateModel;

  const EditAdvocate({super.key, required this.advocateModel});

  @override
  State<EditAdvocate> createState() => _EditAdvocateState();
}

class _EditAdvocateState extends State<EditAdvocate> {
  late FirebaseAuthController firebaseAuthController;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  late TextEditingController nameController;
  late TextEditingController bioController;

  @override
  void initState() {
    firebaseAuthController = Get.find<FirebaseAuthController>();
    nameController = TextEditingController(text: widget.advocateModel.fullName);
    bioController = TextEditingController(text: widget.advocateModel.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            "Edit Profile".tr,
            style: GoogleFonts.blackOpsOne(
              fontSize: 30.sp,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              decorationColor: Colors.black,
              // backgroundColor: Colors.grey.shade100,
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
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
                  'assets/backDesign.png',
                ),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),

                // ~ Profile Photo
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() => firebaseAuthController.image.value == null
                        ? CircleAvatar(
                            radius: 70.r,
                            backgroundImage: NetworkImage(
                                widget.advocateModel.profilePicture!),
                          )
                        : CircleAvatar(
                            radius: 70.r,
                            backgroundImage:
                                FileImage(firebaseAuthController.image.value!),
                          )),
                    Positioned(
                      bottom: 10.h,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          firebaseAuthController.showPhotoOption();
                        },
                        child: CircleAvatar(
                          radius: 14.r,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 12.r,
                            backgroundColor: Colors.grey.shade200,
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: 10.h,
                ),

                // ~ Display name
                Text(
                  widget.advocateModel.fullName.toString().tr,
                  style: GoogleFonts.blackOpsOne(
                    fontSize: 23.sp,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    decorationColor: Colors.black,
                    // backgroundColor: Colors.grey.shade100,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                // ~ change name
                Container(
                  // height: 50.h,
                  // padding: EdgeInsets.symmetric(horizontal: 20.w),
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: TextField(
                    focusNode: _emailFocus,
                    controller: nameController,
                    decoration: InputDecoration(
                        suffix: Text(
                          'name'.tr,
                          style: TextStyle(
                              fontSize: 11.sp, fontStyle: FontStyle.italic),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        hintText: "name".tr),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                Container(
                  // height: 50.h,
                  // padding: EdgeInsets.symmetric(horizontal: 20.w),
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: TextField(
                    focusNode: _bioFocus,
                    controller: bioController,
                    decoration: InputDecoration(
                        suffix: Text(
                          'bio'.tr,
                          style: TextStyle(
                              fontSize: 11.sp, fontStyle: FontStyle.italic),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        hintText: "bio".tr),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                // ~ Gender Selection
                genderSelection(size: size),

                SizedBox(
                  height: 20.h,
                ),

                // ~ Change Password
                Container(
                  height: 50.h,
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                  padding:
                      EdgeInsets.only(left: size.width * 0.05, right: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.snackbar(
                          "Password Change Attemp".tr,
                          "An email has been sent to your Email, You can change the Password from there"
                              .tr,
                          colorText: Colors.white,
                          barBlur: 25.0);
                    },
                    title: Text(
                      "Change Password".tr,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    contentPadding: EdgeInsets.zero,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade600,
                      size: 20.r,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.h,
                ),

                // ~ Save Button
                Obx(
                  () => firebaseAuthController.isLoading.value
                      ? spinkit(color: Colors.blue)
                      : Container(
                          width: size.width,
                          height: 50.h,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                              ),
                              onPressed: () {
                                _emailFocus.unfocus();
                                _bioFocus.unfocus();

                                firebaseAuthController.changeAdvocateProfleData(
                                    context: context,
                                    advocateModel: widget.advocateModel,
                                    nameController: nameController,
                                    bioController: bioController,
                                    userProvider: userProvider);
                              },
                              child: Text(
                                "Save".tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              )),
                        ),
                )
              ],
            ),
          )),
    );
  }

  Widget genderSelection({required Size size}) {
    return GetBuilder(
      init: Get.find<FirebaseAuthController>(),
      builder: (firebasController) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Row(
          children: [
            Text(
              "Gender".tr,
              style: GoogleFonts.blackOpsOne(
                fontSize: 14.sp,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                decorationColor: Colors.black,
                // backgroundColor: Colors.grey.shade100,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 40.w),
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
                  style: GoogleFonts.blackOpsOne(
                    fontSize: 14.sp,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    decorationColor: Colors.black,
                    // backgroundColor: Colors.grey.shade100,
                    color: Colors.black,
                  ),
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
                  style: GoogleFonts.blackOpsOne(
                    fontSize: 14.sp,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    decorationColor: Colors.black,
                    // backgroundColor: Colors.grey.shade100,
                    color: Colors.black,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget showDataFields(
      {required BuildContext context,
      required String title,
      required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: GoogleFonts.blackOpsOne(
              fontSize: 12.sp,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              decorationColor: Colors.black,
              // backgroundColor: Colors.grey.shade100,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 25.sp,
        ),
        Expanded(
          flex: 11,
          child: Text(value, style: TextStyle(color: Colors.grey.shade700)
              // GoogleFonts.blackOpsOne(
              //   fontSize: 12.sp,
              //   textStyle: Theme.of(context).textTheme.bodyMedium,
              //   decorationColor: Colors.black,
              //   // backgroundColor: Colors.grey.shade100,
              //   color: Colors.black,
              // ),
              ),
        ),
      ],
    );
  }
}
