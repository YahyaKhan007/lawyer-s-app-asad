// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';
import 'package:provider/provider.dart';
import '../screens.dart';

import '../widgets/glass_morphism.dart';

class LawyerHomepage extends StatelessWidget {
  final User user;
  final AdvocateModel advocateModel;
  LawyerHomepage({super.key, required this.user, required this.advocateModel});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<IconData> icons = [Icons.person_3_rounded, Icons.language, Icons.logout];
  List<String> pagesName = ['Profile', 'Language change', 'Logout'];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    var pages = [
      AdvocateProfile(userProvider: userProvider),
      ChangeLangugae(
        loggedin: 'Advocate',
      )
    ];
    log(advocateModel.email!);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade400,
        clipBehavior: Clip.antiAlias,
        elevation: 1000,
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                    radius: 100.r,
                    backgroundImage:
                        NetworkImage(advocateModel.profilePicture!)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: ((context, index) {
                    return drawerOption(
                        title: pagesName[index].tr,
                        icon: icons[index],
                        ontap: () {
                          if (index != 2) {
                            Get.to(() => pages[index]);
                          } else {
                            Get.find<FirebaseAuthController>().signoutUser();
                          }
                        });
                  })),
            )
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          leading: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: ClipRRect(
                child: Image.asset(
                  "assets/drawer.png",
                  filterQuality: FilterQuality.high,
                  cacheHeight: 35,
                  color: Colors.white,
                  // fit: BoxFit.cover,
                ),
              )),
          backgroundColor: Colors.blue,
          elevation: 0.1,
          automaticallyImplyLeading: false,
          leadingWidth: 90,
          centerTitle: true,

          // backgroundColor: AppColors.backgroudColor,
          title: Text(
            "HomePage".tr,
            style: GoogleFonts.blackOpsOne(
              fontSize: 25.sp,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              decorationColor: Colors.black,
              // backgroundColor: Colors.grey.shade100,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users", arrayContains: advocateModel.uid)
              .orderBy("updatedOn", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // !   *************************

                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return chatRoomSnapshot.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          // ! we also need a target user model in Order to show the detail of the target user on the HomePage

                          Map<String, dynamic> chatrooms =
                              chatRoomModel.participants!;

                          List<String> participantKey = chatrooms.keys.toList();

                          participantKey.remove(advocateModel.uid);

                          return FutureBuilder(
                              future: FirebaseHelper.getClientModelById(
                                participantKey[0],
                              ),
                              builder: (context, userData) {
                                if (userData.hasData) {
                                  final clientData = userData.data;
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => AdvocateChatroom(
                                            enduser: clientData,
                                            firebaseUser: FirebaseAuth
                                                .instance.currentUser!,
                                            chatRoomModel: chatRoomModel,
                                            currentUserModel: advocateModel,
                                          ));
                                    },
                                    onLongPress: () {},
                                    child: GlassMorphism(
                                        height: 70.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        blur: 80,
                                        borderRadius: 20,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 10.w),
                                          height: 60.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                              child: ListTile(
                                            title: Text(
                                              clientData!.fullName!,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontWeight: FontWeight.bold,
                                                decorationColor: Colors.black,
                                                // backgroundColor: Colors.grey.shade100,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            subtitle: Text(
                                              chatRoomModel.lastMessage != ""
                                                  ? chatRoomModel.lastMessage!
                                                  : "Say hi! to start conversation",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                fontSize: 11.sp,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontWeight: FontWeight.normal,
                                                decorationColor: Colors.black,
                                                // backgroundColor: Colors.grey.shade100,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            leading: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.r,
                                                  backgroundColor:
                                                      Colors.grey.shade500,
                                                  backgroundImage:
                                                      // AssetImage('assets/emotion/happy.png')

                                                      NetworkImage(clientData
                                                          .profilePicture!),
                                                ),
                                                Visibility(
                                                  visible:
                                                      clientData.isVarified!,
                                                  child: Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: CircleAvatar(
                                                          radius: 7.r,
                                                          child: Image.asset(
                                                            "assets/blueTick.png",
                                                            color: Colors.blue,
                                                          ))),
                                                )
                                              ],
                                            ),
                                          )),
                                        )),
                                  );
                                } else {
                                  return Center(
                                    child: spinkit(color: Colors.blue),
                                  );
                                }
                              });
                        })
                    : const Center(
                        // child: Image.asset("assets/noMessageTransparent.png"),
                        child: Text("No Chats founds"),
                      );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                );
              } else {
                Center(
                  child: Text(
                    "No Chats Yet",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                );
              }
            } else {
              return spinkit(color: Colors.blue);
            }
            return const Text("No chats Found");
          },
        ),
      ),
      //  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //   const Text("Lawyer Homepage"),
      //   Text(advocateModel.email!),
      //   ElevatedButton.icon(
      //       onPressed: () {
      //         Get.find<FirebaseAuthController>().signoutUser();
      //       },
      //       icon: const Icon(Icons.logout),
      //       label: const Text("Logout"))
      // ]),
    );
  }

  Widget drawerOption(
      {required String title,
      required IconData icon,
      required VoidCallback ontap}) {
    return ListTile(
      onTap: ontap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
