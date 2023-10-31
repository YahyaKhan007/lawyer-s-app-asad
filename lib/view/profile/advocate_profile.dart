import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/screens.dart';

class AdvocateProfile extends StatelessWidget {
  final UserProvider userProvider;
  const AdvocateProfile({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.back();
                // Get.off(
                //     () => LawyerHomepage(
                //         user: FirebaseAuth.instance.currentUser!,
                //         advocateModel: userProvider.advocateModel!),
                //     transition: Transition.leftToRightWithFade);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: Colors.blue,
          elevation: 0.1,
          automaticallyImplyLeading: false,
          leadingWidth: 90,
          centerTitle: true,

          // backgroundColor: AppColors.backgroudColor,
          title: Text(
            "Profile".tr,
            style: GoogleFonts.blackOpsOne(
              fontSize: 30.sp,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              decorationColor: Colors.black,
              // backgroundColor: Colors.grey.shade100,
              color: Colors.white,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(
                    () => EditAdvocate(
                        advocateModel: userProvider.advocateModel!),
                    duration: const Duration(seconds: 1),
                    transition: Transition.cupertino);
              },
              child: Image.asset(
                "assets/editProfile.png",
                height: 25.h,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10.w,
            )
          ],
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
                  height: 20.h,
                ),
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(userProvider.advocateModel!.profilePicture!),
                  radius: 70.r,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  userProvider.advocateModel!.fullName!.tr,
                  style: GoogleFonts.blackOpsOne(
                    fontSize: 23.sp,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    decorationColor: Colors.black,
                    // backgroundColor: Colors.grey.shade100,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03, vertical: 30.h),
                  height: size.height * 0.4,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.shade100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      showDataFields(
                          context: context,
                          title: 'Email'.tr,
                          value: userProvider.advocateModel!.email!),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.25),
                        child: const Divider(color: Colors.grey),
                      ),
                      showDataFields(
                          context: context,
                          title: 'Bio'.tr,
                          value: userProvider.advocateModel!.bio!),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.25),
                        child: const Divider(color: Colors.grey),
                      ),
                      showDataFields(
                          context: context,
                          title: 'Gender'.tr,
                          value: userProvider.advocateModel!.gender!),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.25),
                        child: const Divider(color: Colors.grey),
                      ),
                      showDataFields(
                          context: context,
                          title: 'Account Type'.tr,
                          value: userProvider.advocateModel!.accountType!),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.25),
                        child: const Divider(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          // boxShadow: [shadow]
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            var firebaseController =
                                Get.put(FirebaseAuthController());

                            firebaseController.signoutUser();
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 35.w)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          child: Text(
                            "Logout".tr,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
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
