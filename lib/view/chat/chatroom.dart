// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laywers_app/services/services.dart';
import 'package:laywers_app/view/screens.dart';

import '../../model/models.dart';
import '../widgets/spinkit.dart';

class Chatroom extends StatelessWidget {
  Chatroom({
    super.key,
    required this.size,
    required this.enduser,
    required this.firebaseUser,
    required this.chatRoomModel,
    required this.currentUserModel,
  });

  final Size size;
  final AdvocateModel enduser;
  final User firebaseUser;
  final ChatRoomModel chatRoomModel;
  final ClientModel currentUserModel;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
          title: GestureDetector(
            onTap: () {
              Get.to(
                () => CheckProfile(enduser: enduser),
                transition: Transition.rightToLeftWithFade,
                duration: const Duration(milliseconds: 500),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: NetworkImage(enduser.profilePicture!),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enduser.fullName!,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      enduser.email!,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        decorationColor: Colors.black,
                        // backgroundColor: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        // color: Colors.blue,
        child: Row(
          children: [
            CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 16.r,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white70,
                      size: 18.r,
                    )),
                onPressed: () {
                  // sendMessage();

                  // provider.randomNameChanger(value: provider.randomName + 1);
                  // randomName = provider.randomName;
                  // setState(() {});
                  // showPhotoOption();
                }),
            Flexible(
                child: TextFormField(
              // textAlignVertical: TextAlignVertical.top,
              // textAlign: TextAlign.center,
              controller:
                  Get.find<ChatroomController>().messageController.value,
              focusNode: _focusNode,
              // enabled: false,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              cursorColor: Colors.black87,
              maxLines: 3,
              minLines: 1,

              // enabled: imageFile != null ? false : true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15.w, right: 10.w),
                  hintText: "Type a messgae ...".tr,
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none),
            )),
            CupertinoButton(
                child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 18.r,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18.r,
                    )),
                onPressed: () {
                  var chatroomController = Get.find<ChatroomController>();
                  _focusNode.unfocus();
                  chatroomController.sendMessage(
                      advocateModel: enduser,
                      clientModel: currentUserModel,
                      msg: chatroomController.messageController.value.text,
                      sender: currentUserModel.accountType!,
                      chatRoomModel: chatRoomModel);
                  // sendMessage(
                  //     msg: messageController.text.trim(),
                  //     emotion: widget.currentUserModel.sendEmotion!
                  //         ? widget.modeProvider.mode
                  //         : null);
                  // widget.modeProvider.emotionList.clear();
                  // _focusNode.unfocus();
                })
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 65.h),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users", arrayContains: currentUserModel.uid)
              .orderBy("updatedOn", descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(chatRoomModel.chatroomid)
                  .collection("messages")
                  .orderBy("createdOn", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    return dataSnapshot.docs.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: ((context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              String messgaeDate =
                                  DateFormat("EEE,dd MMM   hh:mm a").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          currentMessage.createdOn!
                                              .millisecondsSinceEpoch));

                              // currentMessage.sender == currentUserModel.uid
                              //     ? spinkit(color: Colors.blue)
                              //     :
                              return Column(
                                crossAxisAlignment: currentMessage.sender ==
                                        currentUserModel.uid.toString()
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisAlignment: currentMessage.sender ==
                                        currentUserModel.uid.toString()
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  messageContainer(
                                      context: context,
                                      image: currentMessage.image != ""
                                          ? currentMessage.image
                                          : null,
                                      messageText: currentMessage.text == ""
                                          ? null
                                          : currentMessage.text.toString(),
                                      sender: currentMessage.sender ==
                                              currentUserModel.uid
                                          ? 'Advocate'
                                          : 'Client',
                                      time: messgaeDate),
                                ],
                              );
                            }))
                        : const Center(
                            child: Text("No messages yet"),
                          );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Internet Issue"),
                    );
                  } else {
                    return const Center(
                      child: Text("Say hi! to start a conversation"),
                    );
                  }
                } else {
                  return Center(
                    child: spinkit(color: Colors.blue),
                  );
                }
              },
            );
          }),
        ),
      ),
    );
  }

// !  This is Widget in which we will show messages to the user

  Widget messageContainer(
      {required BuildContext context,
      required String? messageText,
      required String? image,
      required String time,
      required String sender}) {
    return Container(
      margin: EdgeInsets.only(
          top: 3.h,
          bottom: 3.h,
          left: sender == 'Client' ? 7.w : 20.w,
          right: sender == 'Client' ? 20.w : 7.w),
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: sender == 'Client'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: sender == 'Client'
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: sender == 'Client'
                        ? Colors.green.shade100
                        : Colors.blue.shade100),
                child: Text(messageText!)),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                time,
                style: TextStyle(fontSize: 9.sp, color: Colors.black87),
              ),
            ),
          ]),
    );
  }
}
