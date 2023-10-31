import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../models.dart';

class ChatroomController extends GetxController {
  Future<ChatRoomModel?> getChatroomModel({
    required AdvocateModel targetUser,
    required ClientModel userModel,
  }) async {
    ChatRoomModel? chatRoom;
    // Loading.showLoadingDialog(context, "Creating");
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatRoom;

      log("Already Existed");
    } else {
      // Loading.showLoadingDialog(context, "Creating");

      ChatRoomModel newChatRoom = ChatRoomModel(
          createdOn: Timestamp.now(),
          chatroomid: uuid.v1(),
          lastMessage: "",
          readMessage: null,
          fromUser: null,
          participants: {
            userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          },
          users: [userModel.uid.toString(), targetUser.uid.toString()],
          updatedOn: Timestamp.now());
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;

      log("New Charoom Created");
    }
    return chatRoom;
  }

  var messageController = TextEditingController().obs;
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;
  set imageFile(File? file) {
    _imageFile.value = file;
  }

  // ~ Send Message
  void sendMessage(
      {required ClientModel clientModel,
      required AdvocateModel advocateModel,
      required String? msg,
      required String sender,
      required ChatRoomModel chatRoomModel}) async {
    MessageModel? messageModel;
    // String? msg = messageController.text.trim();
    messageController.value.clear();
    log("\nThe Sender is       ${sender == 'Client' ? clientModel.fullName : advocateModel.fullName}\n");
    log("\nThe Sender is       ${sender == 'Client' ? clientModel.uid : advocateModel.uid}\n");
    var id = const Uuid();
// ! for simple message
    if (msg != "" && imageFile == null) {
      messageModel = MessageModel(
          createdOn: Timestamp.now(),
          image: "",
          messageId: uuid.v1(),
          seen: false,
          sender: sender == 'Client' ? clientModel.uid : advocateModel.uid,
          reciever: sender == 'Client' ? advocateModel.uid : clientModel.uid,
          text: msg);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .collection("messages")
          .doc(messageModel.messageId)
          .set(messageModel.toMap());
      // .then((value) => sendPushNotificatio(widget.enduser, msg!));

// !****************************************************
//  ? ****************************************************
      chatRoomModel.updatedOn = Timestamp.now();
      chatRoomModel.readMessage = null;
      chatRoomModel.fromUser =
          sender == 'Client' ? clientModel.uid : advocateModel.uid;
      chatRoomModel.lastMessage = msg;

      // !****************************************************
//  ? ****************************************************

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .set(chatRoomModel.toMap());
      // .then((value) => LocalNotificationServic.sendPushNotificatio(
      //     widget.enduser, msg!)
      // );

      // log("Message has been send");
    }

    // ! for message with picture
    else if (imageFile != null && msg != "") {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref(
              "PicturesBetween${clientModel.fullName} and ${advocateModel.fullName}")
          .child(id.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
      String imageUrl = await snapshot.ref.getDownloadURL();
      messageModel = MessageModel(
          createdOn: Timestamp.now(),
          image: imageUrl,
          messageId: uuid.v1(),
          seen: false,
          sender: sender == 'Client' ? clientModel.uid : advocateModel.uid,
          reciever: sender == 'Client' ? advocateModel.uid : clientModel.uid,
          text: msg);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .collection("messages")
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      chatRoomModel.updatedOn = Timestamp.now();
      chatRoomModel.readMessage = null;
      chatRoomModel.fromUser =
          sender == 'Client' ? clientModel.uid : advocateModel.uid;
      chatRoomModel.lastMessage = msg;

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .set(chatRoomModel.toMap());
      // .then((value) => LocalNotificationServic.sendPushNotificatio(
      //     widget.enduser, msg!));
      // final provider = Provider.of<LoadingProvider>(context, listen: false);
      // provider.sendPhotoCmplete(value: true);

      // log("Message has been send");
    }

    // ! for just picture

    else if (msg == "" && imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref(
              "Pictures from ${clientModel.fullName} to ${advocateModel.fullName}")
          .child(id.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
      String imageUrl = await snapshot.ref.getDownloadURL();
      messageModel = MessageModel(
          createdOn: Timestamp.now(),
          image: imageUrl,
          messageId: uuid.v1(),
          seen: false,
          sender: sender == 'Client' ? clientModel.uid : advocateModel.uid,
          reciever: sender == 'Client' ? advocateModel.uid : clientModel.uid,
          text: "");

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .collection("messages")
          .doc(messageModel.messageId)
          .set(messageModel.toMap());
      // .then((value) => LocalNotificationServic.sendPushNotificatio(
      //     widget.currentUserModel, "Photo"));

      chatRoomModel.updatedOn = Timestamp.now();
      chatRoomModel.readMessage = null;
      chatRoomModel.fromUser =
          sender == 'Client' ? clientModel.uid : advocateModel.uid;
      chatRoomModel.lastMessage = "photo";

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .set(chatRoomModel.toMap());

      // log("Message has been send");

      // final provider = Provider.of<LoadingProvider>(context, listen: false);
      // provider.sendPhotoCmplete(value: true);
    }
  }
}
