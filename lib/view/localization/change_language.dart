// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/main.dart';

import '../../drawer_screen.dart';
import '../../services/services.dart';

class ChangeLangugae extends StatelessWidget {
  final String loggedin;
  ChangeLangugae({super.key, required this.loggedin});

  var langController = Get.put(LangController());

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FirebaseAuthController>();

    // UserProvider UserProvider =
    //     Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: AppBar(
            // leading: drawerIcon(context),
            leading: GestureDetector(
              onTap: () {
                if (loggedin == 'Advocate') {
                  Get.back();
                } else {
                  drawerController.toggle!();
                }
              },
              child: loggedin == 'Advocate'
                  ? const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )
                  : Image.asset(
                      'assets/drawer.png',
                      color: Colors.white,
                      cacheHeight: 35,
                    ),
            ),
            backgroundColor: Colors.blue,
            elevation: 0.1,
            automaticallyImplyLeading: false,
            leadingWidth: 90,
            centerTitle: true,
            // backgroundColor: AppColors.backgroudColor,
            title: Text(
              "Language change".tr,
              style: GoogleFonts.blackOpsOne(
                fontSize: 22.sp,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                decorationColor: Colors.black,
                // backgroundColor: Colors.grey.shade100,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: ListView(children: [
          GestureDetector(
            onTap: () {
              langController.changeLocal(
                langCode: 'en',
                countryCode: 'US',
              );
              prefs!.setString('Country_Code', 'US');
              prefs!.setString('Language_Code', 'en');

              controller.hindhi.value = '';
              controller.english.value = 'English';
              controller.urdu.value = '';

              log(prefs!.hashCode.toString());
              log(prefs!.getString("Country_Code").toString());
              log(prefs!.getString("Language_Code").toString());
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: Text(
                        "Eng",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text(
                    'English',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  trailing: Visibility(
                      visible: 'English' == controller.english.value,
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.green,
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.r,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w, right: 30.w),
                  child: const Divider(),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              langController.changeLocal(
                langCode: 'ur',
                countryCode: 'PK',
              );
              prefs!.setString('Country_Code', 'PK');
              prefs!.setString('Language_Code', 'ur');
              controller.hindhi.value = '';
              controller.english.value = '';
              controller.urdu.value = 'Urdu';

              log(prefs!.hashCode.toString());
              log(prefs!.getString("Country_Code").toString());
              log(prefs!.getString("Language_Code").toString());
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: Text(
                        "Urd",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text(
                    'Urdu',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  trailing: Visibility(
                      visible: 'Urdu' == controller.urdu.value,
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.green,
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.r,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w, right: 30.w),
                  child: const Divider(),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              langController.changeLocal(
                langCode: 'hi',
                countryCode: 'IN',
              );
              prefs!.setString('Country_Code', 'IN');
              prefs!.setString('Language_Code', 'hi');
              controller.hindhi.value = 'Hindhi';
              controller.english.value = '';
              controller.urdu.value = '';

              log(prefs!.hashCode.toString());
              log(prefs!.getString("Country_Code").toString());
              log(prefs!.getString("Language_Code").toString());
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: Text(
                        "Hin",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text(
                    'Hindhi',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  trailing: Visibility(
                      visible: 'Hindhi' == controller.hindhi.value,
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.green,
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.r,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w, right: 30.w),
                  child: const Divider(),
                )
              ],
            ),
          ),
        ]));
  }

  // Widget changeLanguage(
  //     {required String name,
  //     required String langCode,
  //     required String countryCode,
  //     required UserProvider UserProvider}) {
  //   return GestureDetector(
  //     onTap: () {
  //       langController.changeLocal(
  //           langCode: langCode, countryCode: countryCode);
  //       prefs!.setString('Country_Code', countryCode);
  //       prefs!.setString('Language_Code', langCode);

  //       log(prefs!.hashCode.toString());
  //       log(prefs!.getString("Country_Code").toString());
  //       log(prefs!.getString("Language_Code").toString());
  //     },
  //     child: Column(
  //       children: [
  //         ListTile(
  //           leading: CircleAvatar(
  //             backgroundColor: Colors.blue,
  //             child: Center(
  //               child: Text(
  //                 name[0] + name[1] + name[2],
  //                 style: TextStyle(fontSize: 12.sp, color: Colors.white),
  //               ),
  //             ),
  //           ),
  //           title: Text(
  //             name,
  //             style: TextStyle(
  //               fontSize: 15.sp,
  //             ),
  //           ),
  //           trailing: Visibility(
  //               visible: name == controller.english.value,
  //               child: CircleAvatar(
  //                 radius: 10.r,
  //                 backgroundColor: Colors.green,
  //                 child: Center(
  //                   child: Icon(
  //                     Icons.check,
  //                     color: Colors.white,
  //                     size: 15.r,
  //                   ),
  //                 ),
  //               )),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 70.w, right: 30.w),
  //           child: const Divider(),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
