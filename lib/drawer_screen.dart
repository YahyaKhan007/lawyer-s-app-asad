// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:provider/provider.dart';

final drawerController = ZoomDrawerController();

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.clientModel});

  var firebaseController = Get.find<FirebaseAuthController>();

  final ClientModel clientModel;

  final List screens = [
    const Profile(),
    const MyIb(),
    const Advocates(),
    ChangeLangugae(
      loggedin: 'Client',
    ),

    // ChatPage()
    // EmotionDetector()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
          slideWidth: 270.w,
          controller: drawerController,
          menuScreen: MenuScreen(),
          mainScreen: Obx(() => screens[firebaseController.screenIndex.value])),
    );
  }
}

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  FirebaseAuthController firebaseAuthController =
      Get.find<FirebaseAuthController>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      body: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: clientProvider.clientModel.accountType == 'Client'
              //           ? const NetworkImage(
              //               "https://img.freepik.com/premium-vector/gray-school-board-chalkboard-texture-background_114588-1517.jpg")
              //           : const NetworkImage(
              //               "https://assets.entrepreneur.com/content/3x2/2000/20150929184415-law-and-justice-patent.jpeg"),
              //       fit: BoxFit.cover),
              // ),
              child: DrawerHeader(
                child: CircleAvatar(
                  radius: 90.r,
                  backgroundImage: NetworkImage(
                      userProvider.clientModel?.profilePicture ?? ""),
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/homepage.png',
                scale: 20,
                height: 15.h,
                color: (firebaseAuthController.screenIndex.value == 10)
                    ? Colors.yellow
                    : Colors.white,
              ),
              title: Text(
                "HomePage".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (firebaseAuthController.screenIndex.value == 10)
                      ? Colors.yellow
                      : Colors.white,
                  fontWeight: (firebaseAuthController.screenIndex.value == 10
                      ? FontWeight.bold
                      : FontWeight.normal),
                ),
              ),

              onTap: () {
                Get.snackbar(
                    "Not Implemented", "Homepage will be implemented soon");
              },
              // leading: ,
            ),
            ListTile(
              leading: Image.asset(
                'assets/profile.png',
                scale: 20,
                height: 20.h,
                color: (firebaseAuthController.screenIndex.value == 0)
                    ? Colors.yellow
                    : Colors.white,
              ),
              title: Text(
                "Profile".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (firebaseAuthController.screenIndex.value == 0)
                      ? Colors.yellow
                      : Colors.white,
                  fontWeight: (firebaseAuthController.screenIndex.value == 0
                      ? FontWeight.bold
                      : FontWeight.normal),
                ),
              ),

              onTap: () {
                firebaseAuthController.changeScreenIndex(index: 0);
                drawerController.toggle!();
              },
              // leading: ,
            ),
            ListTile(
              leading: Image.asset(
                'assets/inbox.png',
                scale: 20,
                height: 20.h,
                color: (firebaseAuthController.screenIndex.value == 1)
                    ? Colors.yellow
                    : Colors.white,
              ),
              title: Text(
                "Inbox".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (firebaseAuthController.screenIndex.value == 1)
                      ? Colors.yellow
                      : Colors.white,
                  fontWeight: (firebaseAuthController.screenIndex.value == 1
                      ? FontWeight.bold
                      : FontWeight.normal),
                ),
              ),

              onTap: () {
                firebaseAuthController.changeScreenIndex(index: 1);
                drawerController.toggle!();
              },
              // leading: ,
            ),
            ListTile(
              leading: Image.asset(
                'assets/lawyer.png',
                scale: 20,
                height: 20.h,
                color: (firebaseAuthController.screenIndex.value == 2)
                    ? Colors.yellow
                    : Colors.white,
              ),
              title: Text(
                "Select Lawyers".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (firebaseAuthController.screenIndex.value == 2)
                      ? Colors.yellow
                      : Colors.white,
                  fontWeight: (firebaseAuthController.screenIndex.value == 2
                      ? FontWeight.bold
                      : FontWeight.normal),
                ),
              ),

              onTap: () {
                firebaseAuthController.changeScreenIndex(index: 2);
                drawerController.toggle!();
              },
              // leading: ,
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: (firebaseAuthController.screenIndex.value == 3)
                    ? Colors.yellow
                    : Colors.white,
              ),
              title: Text(
                "Language change".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (firebaseAuthController.screenIndex.value == 3)
                      ? Colors.yellow
                      : Colors.white,
                  fontWeight: (firebaseAuthController.screenIndex.value == 3
                      ? FontWeight.bold
                      : FontWeight.normal),
                ),
              ),

              onTap: () {
                firebaseAuthController.changeScreenIndex(index: 3);
                drawerController.toggle!();
              },
              // leading: ,
            ),
            SizedBox(
              height: 100.h,
            ),
            const Divider(),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Image.asset(
                'assets/logout.png',
                scale: 20,
                height: 20.h,
                color: Colors.red,
              ),
              title: Text(
                "Logout".tr,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),

              onTap: () {
                firebaseAuthController.signoutUser();
                drawerController.toggle!();
              },
              // leading: ,
            ),
          ],
        ),
      ),
    );
  }
}

class MyIb extends StatelessWidget {
  const MyIb({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Inbox(
      clientModel: userProvider.clientModel!,
      //  advocateModel: advocateModel
    );
  }
}
