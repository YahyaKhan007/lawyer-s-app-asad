import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:laywers_app/view/widgets/drawe_icon.dart';
// import 'package:swipe_cards/swipe_cards.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

class Advocates extends StatefulWidget {
  const Advocates({super.key});

  @override
  State<Advocates> createState() => _AdvocatesState();
}

class _AdvocatesState extends State<Advocates> {
  late FirebaseAuthController firebaseController;
  late AdvocateProvider advocateProvider;
  late UserProvider userProvider;
  @override
  void initState() {
    firebaseController = Get.find<FirebaseAuthController>();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
    // firebaseController.isLoading.value = true;
    Future.delayed(const Duration(seconds: 2),
        () => firebaseController.isLoading.value = false);
    advocateProvider = Provider.of<AdvocateProvider>(context, listen: false);

    // Call the init method to fetch all users
    advocateProvider.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    // Access the users from the AdvocateProvider
    final allAdvocates = Provider.of<AdvocateProvider>(context).users;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: AppBar(
            leading: drawerIcon(context),
            backgroundColor: Colors.blue,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 90,
            centerTitle: true,
            // backgroundColor: AppColors.backgroudColor,
            title: Text(
              "Lawyers".tr,
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
        body: allAdvocates.isEmpty
            ? const Center(
                child: Text('Currently there are no advocate'),
              )
            : Obx(
                () => firebaseController.isLoading.value
                    ? Center(child: spinkit(color: Colors.blue))
                    : PageView.builder(
                        scrollDirection: Axis.horizontal,
                        allowImplicitScrolling: true,
                        itemCount: allAdvocates.length,
                        itemBuilder: (context, index) {
                          log('Only One User + ${allAdvocates[0].fullName!}');
                          log('ALL Users are   + ${allAdvocates.length}');
                          return showAdvocate(
                              currentUserModel: userProvider.clientModel!,
                              advocateModel: allAdvocates[index],
                              context: context,
                              size: size,
                              index: index);
                        }),
              ));
  }

  Widget showAdvocate(
      {required AdvocateModel advocateModel,
      required ClientModel currentUserModel,
      required BuildContext context,
      required Size size,
      required int index}) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    advocateModel.profilePicture!,
                  ),
                  fit: BoxFit.cover),
            ),
            child: FutureBuilder<void>(
              future: precacheImage(
                NetworkImage(
                  advocateModel.profilePicture!,
                ),
                context,
              ),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: spinkit(color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  // Handle the error
                  return const Text('Error loading image');
                } else {
                  // Image is loaded, display it
                  return Image.network(advocateModel.profilePicture!);
                }
              },
            ),
          ),
          Positioned(
            bottom: 0.h,
            // left: 20.w,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          advocateModel.fullName!,
                          style: GoogleFonts.oswald(
                            fontSize: 30.sp,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            decorationColor: Colors.black,
                            // backgroundColor: Colors.grey.shade100,
                            color: Colors.greenAccent,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Visibility(
                          visible: advocateModel.isVarified! ? true : false,
                          child: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.transparent,
                              child: Image.asset("assets/blueTick.png")),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        advocateModel.ratings!.isNotEmpty
                            ? Row(
                                children: [
                                  Text(
                                    firebaseController.averageRating[index]
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 25.r,
                                    color: Colors.yellow,
                                  )
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Text(
                      advocateModel.email!,
                      style: GoogleFonts.oswald(
                        fontSize: 13.sp,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      advocateModel.gender!,
                      style: GoogleFonts.oswald(
                        fontSize: 13.sp,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      advocateModel.bio!,
                      style: GoogleFonts.oswald(
                        fontSize: 13.sp,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      advocateModel.isVarified!
                          ? 'Account Varified'
                          : "Account Not varified",
                      style: GoogleFonts.oswald(
                        fontSize: 13.sp,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: advocateModel.isVarified!
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    advocateModel.ratings!.isEmpty
                        ? Text(
                            'Not yet Rated',
                            style:
                                TextStyle(fontSize: 13.sp, color: Colors.red),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // ~ Chatroom detection

                            firebaseController.isOpen.value = true;

                            var chatroomController =
                                Get.find<ChatroomController>();
                            ChatRoomModel? chatRoom =
                                await chatroomController.getChatroomModel(
                                    targetUser: advocateModel,
                                    userModel: currentUserModel);
                            firebaseController.isOpen.value = false;

                            Get.to(
                              () => Chatroom(
                                  size: size,
                                  enduser: advocateModel,
                                  firebaseUser:
                                      FirebaseAuth.instance.currentUser!,
                                  chatRoomModel: chatRoom!,
                                  currentUserModel: currentUserModel),
                              transition: Transition.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                          child: Obx(
                            () => CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.green,
                              child: firebaseController.isOpen.value
                                  ? spinkit(color: Colors.white)
                                  : Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 25.sp,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 30.h,
          //   child:
          // )
        ],
      ),
    );
  }
}
