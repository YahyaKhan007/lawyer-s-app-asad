// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/advocate_model.dart';
import 'package:laywers_app/services/firebase_auth_controller.dart';
import 'package:laywers_app/view/widgets/glass_morphism.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';

import '../../model/adminModel.dart';

class AdminHomePage extends StatefulWidget {
  final AdminModel adminModel;
  const AdminHomePage({super.key, required this.adminModel});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var controller = Get.find<FirebaseAuthController>();

  List<Map<String, dynamic>> pendingApproval = [];

  @override
  void initState() {
    _getReceiverNames();
    // _getSenderNames();
    super.initState();

    log("Original init executed");
  }

  Future<void> _getReceiverNames() async {
    controller.isLoading.value = true;
    final userRef = FirebaseFirestore.instance
        .collection('admin_user')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final userSnapshot = await userRef.get();
    final pendingList = userSnapshot.get('pending');

    for (final receiverUid in pendingList) {
      final receiverRef = FirebaseFirestore.instance
          .collection('advocate_users')
          .doc(receiverUid);
      final receiverSnapshot = await receiverRef.get();
      final receiverData = receiverSnapshot.data();

      setState(() {
        try {
          pendingApproval.add(receiverData!);
          log("=============> $receiverData");
        } catch (e) {
          log(e.toString());
        }
      });

      log("total receiverNames ********* ${pendingApproval.length}");
    }
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 400),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: AppBar(
            // leading: drawerIcon(context),

            backgroundColor: Colors.blue,
            elevation: 0,
            automaticallyImplyLeading: false,
            // leadingWidth: 150,
            centerTitle: true,
            bottom: const TabBar(
                dividerColor: Colors.white,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // Style for the selected tab
                unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey), // Style for unselected tabs

                tabs: [
                  Tab(
                    text: 'Pending',
                  ),
                  Tab(text: 'Notification'),
                ]),
            // backgroundColor: AppColors.backgroudColor,
            title: Text(
              "Admin Page".tr,
              style: GoogleFonts.blackOpsOne(
                fontSize: 26.sp,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                decorationColor: Colors.black,
                // backgroundColor: Colors.grey.shade100,
                color: Colors.white,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.find<FirebaseAuthController>().signoutUser();
                },
                child: Icon(
                  Icons.logout,
                  size: 22.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: TabBarView(
            children: [
              controller.isLoading.value
                  ? Center(child: spinkit(color: Colors.blue))
                  : pendingApproval.isEmpty
                      ? const Center(
                          child: Text("There are no pending Approvals"),
                        )
                      : Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: pendingApproval.length,
                                    itemBuilder: ((context, index) {
                                      return GlassMorphism(
                                        width: size.width,
                                        height: 60.h,
                                        blur: 20,
                                        borderRadius: 20,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                pendingApproval[index]
                                                    ['profilePicture']),
                                          ),
                                          title: Text(
                                            pendingApproval[index]['fullName'],
                                            style: TextStyle(
                                                color: Colors.blue.shade900,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            pendingApproval[index]['email'],
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          trailing: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    AdvocateModel advocateUser =
                                                        AdvocateModel.fromMap(
                                                            pendingApproval[
                                                                index]);
                                                    // ! For                 Confirm Click
                                                    onClickOkay(
                                                        index: index,
                                                        advocateUser:
                                                            advocateUser);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    radius: 15.r,
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 18.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    AdvocateModel advocateUser =
                                                        AdvocateModel.fromMap(
                                                            pendingApproval[
                                                                index]);
                                                    onDismissed(
                                                        advocateUser:
                                                            advocateUser);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    radius: 15.r,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 18.sp,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      );
                                    })))
                          ],
                        ),
              const Center(
                child: Text("Not yet Implemented"),
              )
            ],
          ),
        ),
      ),
    );
  }

  onDismissed({
    required AdvocateModel advocateUser,
  }) async {
    try {
      controller.isLoading.value = true;
      if (controller.isLoading.value) {
        Get.dialog(barrierDismissible: true, spinkit(color: Colors.white));
      }

      widget.adminModel.pending!.remove(advocateUser.uid);

      await FirebaseFirestore.instance
          .collection('admin_user')
          .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
          .set(widget.adminModel.toMap());

      pendingApproval.removeWhere((advocateData) {
        return advocateData['uid'] == advocateUser.uid;
      });

      controller.isLoading.value = false;

      if (controller.isLoading.value == false) {
        Get.back();
      }
      setState(() {});
      log('just removed');
    } catch (e) {
      controller.isLoading.value = false;
    }
  }

  onClickOkay({required AdvocateModel advocateUser, required int index}) async {
    try {
      controller.isLoading.value = true;
      if (controller.isLoading.value) {
        Get.dialog(barrierDismissible: true, spinkit(color: Colors.white));
      }

      advocateUser.isVarified = true;
      uploadFirebase();

      widget.adminModel.pending!.remove(advocateUser.uid);

      await FirebaseFirestore.instance
          .collection('advocate_users')
          .doc(advocateUser.uid)
          .set(advocateUser.toMap());

      await FirebaseFirestore.instance
          .collection('admin_user')
          .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
          .set(widget.adminModel.toMap());

      pendingApproval.removeWhere((advocateData) {
        return advocateData['uid'] == advocateUser.uid;
      });

      controller.isLoading.value = false;

      if (controller.isLoading.value == false) {
        Get.back();
      }
      setState(() {});
      log('just removed');
    } catch (e) {
      controller.isLoading.value = false;
    }
  }

  uploadFirebase() async {}
}
