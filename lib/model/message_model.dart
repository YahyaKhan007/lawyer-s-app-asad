import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? sender;
  String? reciever;
  String? text;
  // String? emotion;
  bool? seen;
  Timestamp? createdOn;
  Timestamp? readTime;
  String? image;

// ! simple Constructor
  MessageModel(
      {this.messageId,
      this.sender,
      this.reciever,
      this.text,
      this.seen,
      // this.emotion,
      this.createdOn,
      this.readTime,
      this.image});

//  !  will be Used to change your Map/Json data into MessageModel
  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];

    sender = map["sender"];
    reciever = map["reciever"];
    text = map["text"];
    seen = map["seen"];
    // emotion = map["emotion"];
    createdOn = map["createdOn"];
    readTime = map["readTime"];
    image = map["image"];
  }

//  !  will be Used to change your MessageModel object into Map/Json
  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "reciever": reciever,
      "text": text,
      "seen": seen,
      // "emotion": emotion,
      "createdOn": createdOn,
      "readTime": readTime,
      "image": image
    };
  }
}
