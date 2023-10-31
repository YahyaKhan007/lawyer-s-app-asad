import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/services/user_provider.dart';
import 'package:laywers_app/view/chat/chatroom.dart';
import 'package:laywers_app/view/widgets/drawe_icon.dart';
import 'package:laywers_app/view/widgets/glass_morphism.dart';
import 'package:laywers_app/view/widgets/spinkit.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_helper.dart';

class Inbox extends StatelessWidget {
  const Inbox({
    super.key,
    required this.clientModel,

    //  required this.advocateModel
  });

  final ClientModel clientModel;
  // final AdvocateModel advocateModel;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          leading: drawerIcon(context),
          backgroundColor: Colors.blue,
          elevation: 0.1,
          automaticallyImplyLeading: false,
          leadingWidth: 90,
          centerTitle: true,
          // backgroundColor: AppColors.backgroudColor,
          title: Text(
            "Inbox",
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
      // body: WillPopScope(
      //     child: const Center(child: Text("No Chats Found")),
      //     onWillPop: () {
      //       return Future.delayed(
      //         const Duration(seconds: 3),
      //       );
      //     }),
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users", arrayContains: userProvider.clientModel!.uid)
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

                          participantKey.remove(userProvider.clientModel!.uid);

                          return FutureBuilder(
                              future: FirebaseHelper.geAdvocateModelById(
                                participantKey[0],
                              ),
                              builder: (context, userData) {
                                if (userData.hasData) {
                                  final advocateModel = userData.data;
                                  return GestureDetector(
                                    onTap: () {},
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
                                                onTap: () {
                                                  Get.to(() => Chatroom(
                                                      size:
                                                          MediaQuery.of(context)
                                                              .size,
                                                      enduser: advocateModel,
                                                      firebaseUser: FirebaseAuth
                                                          .instance
                                                          .currentUser!,
                                                      chatRoomModel:
                                                          chatRoomModel,
                                                      currentUserModel:
                                                          clientModel));
                                                },
                                                leading: Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 23.r,
                                                      backgroundColor:
                                                          Colors.grey.shade500,
                                                      backgroundImage:
                                                          // AssetImage('assets/emotion/happy.png')

                                                          NetworkImage(
                                                              advocateModel!
                                                                  .profilePicture!),
                                                    ),
                                                    Visibility(
                                                      visible: userProvider
                                                          .clientModel!
                                                          .isVarified!,
                                                      child: Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              radius: 10.r,
                                                              child:
                                                                  Image.asset(
                                                                "assets/blueTick.png",
                                                                color:
                                                                    Colors.blue,
                                                              ))),
                                                    )
                                                  ],
                                                ),
                                                title: Text(
                                                  advocateModel.fullName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.sp,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontWeight: FontWeight.bold,
                                                    decorationColor:
                                                        Colors.black,
                                                    // backgroundColor: Colors.grey.shade100,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  chatRoomModel.lastMessage !=
                                                          ""
                                                      ? chatRoomModel
                                                          .lastMessage!
                                                      : "Say hi! to start conversation",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 11.sp,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decorationColor:
                                                        Colors.black,
                                                    // backgroundColor: Colors.grey.shade100,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                trailing:
                                                    // chatRoomModel.readMessage !=
                                                    //         null
                                                    //     ?
                                                    Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat(" dd MMM yyy")
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  chatRoomModel
                                                                      .updatedOn!
                                                                      .millisecondsSinceEpoch)),
                                                      style: TextStyle(
                                                          fontSize: 8.sp,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                    Text(
                                                      DateFormat(" hh:mm")
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  chatRoomModel
                                                                      .updatedOn!
                                                                      .millisecondsSinceEpoch)),
                                                      style: TextStyle(
                                                          fontSize: 8.sp,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ],
                                                )
                                                // : const CircleAvatar(
                                                //     backgroundColor: Colors.blue,
                                                //     radius: 7,
                                                //   ),
                                                ),
                                          ),
                                        )),
                                  );
                                } else {
                                  return Center(
                                      child: spinkit(color: Colors.blue));
                                }

                                //  AdvocateModel userModel =
                                //                     userData.data as AdvocateModel;
                                // AdvocateModel advocateModel =
                                //     userData.data as AdvocateModel;
                              });
                        })
                    : const Center(
                        // child: Image.asset("assets/noMessageTransparent.png"),
                        child: Text("No Messages founds"),
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
    );
  }
}
