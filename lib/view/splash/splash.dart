import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final User? firebaseUser;
  final ClientModel? clientModel;
  final AdminModel? adminModel;
  final AdvocateModel? advocateModel;
  const SplashScreen(
      {super.key,
      required this.firebaseUser,
      required this.clientModel,
      required this.advocateModel,
      this.adminModel});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserProvider userProvider;
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // var langController = Get.find<LangController>();

    Future.delayed(const Duration(seconds: 1), () {
      if (widget.firebaseUser != null) {
        userProvider.updateClientUser(widget.clientModel);
        userProvider.updateFirebaseUser(widget.firebaseUser!);
        userProvider.updateAdvocateModel(widget.advocateModel);

        // checkEmailVerificationStatus();
      }

      Get.offAll(() => widget.firebaseUser != null
          ? widget.clientModel != null && widget.clientModel!.fullName == ""
              ? CompleteProfile(
                  advocateModel: widget.advocateModel,
                  clientModel: widget.clientModel!,
                  firebaseUser: widget.firebaseUser!)
              : widget.advocateModel != null &&
                      widget.advocateModel!.fullName == ""
                  ? CompleteProfile(
                      advocateModel: widget.advocateModel,
                      clientModel: widget.clientModel,
                      firebaseUser: widget.firebaseUser!)
                  : widget.clientModel != null
                      ?
                      // ^ Client View
                      MyHomePage(
                          clientModel: widget.clientModel!,
                        )
                      : widget.advocateModel != null
                          ?
                          // ^ Advocate View
                          LawyerHomepage(
                              advocateModel: widget.advocateModel!,
                              user: widget.firebaseUser!,
                            )
                          : AdminHomePage(
                              adminModel: widget.adminModel!,
                            )
          : const Login());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      body: Center(
        child: Text(
          "Splash Screen".tr,
          style: GoogleFonts.blackOpsOne(
            fontSize: 30.sp,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            decorationColor: Colors.black,
            // backgroundColor: Colors.grey.shade100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
