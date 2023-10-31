import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  String? fromUser;
  Map<String, dynamic>? participants;
  String? lastMessage;
  Timestamp? createdOn;
  Timestamp? readMessage;
  Timestamp? updatedOn;
  List<dynamic>? users;

// ! simple Constructor
  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.fromUser,
      this.lastMessage,
      this.createdOn,
      this.readMessage,
      this.updatedOn,
      this.users});

//  !  will be Used to change your Map/Json data into ChatRoomModel
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    fromUser = map["fromUser"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    createdOn = map["createdOn"];
    updatedOn = map["updatedOn"];
    readMessage = map["readMessage"];
    users = map["users"];
  }

//  !  will be Used to change your ChatRoomModel object into Map/Json
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "fromUser": fromUser,
      "participants": participants,
      "lastmessage": lastMessage,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
      "readMessage": readMessage,
      "users": users,
    };
  }
}
