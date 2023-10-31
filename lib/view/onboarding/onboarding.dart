import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laywers_app/view/complete_profile.dart/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  final SharedPreferences prefs;
  const OnBoarding({super.key, required this.prefs});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    widget.prefs.setString('firstTime', 'No');
    Get.offAll(() => const Signup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
