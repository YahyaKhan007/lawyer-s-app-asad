import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/advocate_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';
import 'package:provider/provider.dart';

class CheckProfile extends StatelessWidget {
  final AdvocateModel enduser;
  const CheckProfile({super.key, required this.enduser});

  @override
  Widget build(BuildContext context) {
    List<dynamic> rateddd = enduser.ratedFrom!;
    var authController = Get.find<FirebaseAuthController>();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              )),
          backgroundColor: Colors.blue,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 60,
          // backgroundColor: AppColors.backgroudColor,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/backDesign.png',
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                      backgroundColor: Colors.white24,
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: Image.network(enduser.profilePicture!),
                      ));
                },
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundImage: NetworkImage(enduser.profilePicture!),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                enduser.fullName!.tr,
                style: GoogleFonts.blackOpsOne(
                  fontSize: 23.sp,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  decorationColor: Colors.black,
                  // backgroundColor: Colors.grey.shade100,
                  color: Colors.black,
                ),
              ),
              Text(
                enduser.email!.tr,
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  decorationColor: Colors.black,
                  // backgroundColor: Colors.grey.shade100,
                  color: Colors.black,
                ),
              ),

              //  ~ show ratings

              SizedBox(
                height: 100.h,
              ),

              Visibility(
                visible: enduser.ratedFrom!
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? false
                    : true,
                child: SizedBox(
                  width: size.width,
                  height: 130,
                  child: ListTile(
                    title: Text(
                      "Please rate the Advocate",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    subtitle: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        authController.rate.value = rating;
                        print(authController.rate.value);
                      },
                    ),
                    trailing: authController.isLoading.value
                        ? spinkit(color: Colors.blue)
                        : TextButton(
                            onPressed: () {
                              print(
                                  "You give ${authController.rate.value} ratings to the advocate");
                              authController.ratetheAdvocate(
                                advocateModel: enduser,
                                userProvider: userProvider,
                              );
                            },
                            child: const Text("Submit"),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
