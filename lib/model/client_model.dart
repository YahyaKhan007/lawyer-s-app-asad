import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String? uid;
  String? fullName;
  String? email;
  String? pushToken;
  String? profilePicture;
  String? accountType;
  String? gender;
  // List? friends;
  // List? sender;
  // List? reciever;
  String? bio;
  Timestamp? memberSince;
  bool? isVarified;
  // bool? sendEmotion;
// ! simple Constructor
  ClientModel(
      {required this.uid,
      // required this.sendEmotion,
      required this.fullName,
      required this.email,
      required this.bio,
      required this.gender,
      // required this.sender,
      // required this.reciever,
      // required this.friends,
      required this.memberSince,
      required this.accountType,
      required this.pushToken,
      required this.isVarified,
      required this.profilePicture});

//  !  will be Used to change your Map/Json data into UserModel
  ClientModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    gender = map["gender"];
    // friends = map["friends"];
    // sender = map["sender"];
    // reciever = map["reciever"];
    memberSince = map["memberSince"];
    pushToken = map["pushToken"];
    accountType = map["accountType"];
    isVarified = map['isVarified'];
    profilePicture = map["profilePicture"];
    bio = map["bio"];
    // sendEmotion = map["sendEmotion"];
  }

//  !  will be Used to change your UserModel object into Map/Json
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "gender": gender,
      // "friends": friends,
      // "sender": sender,
      // "reciever": reciever,
      "memberSince": memberSince,
      "accountType": accountType,
      "profilePicture": profilePicture,
      "pushToken": pushToken,
      'isVarified': isVarified,
      "bio": bio,
      // "sendEmotion": sendEmotion
    };
  }

  factory ClientModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ClientModel(
      uid: snapshot.id,
      fullName: data['fullName'],
      email: data['email'],
      pushToken: data['pushToken'],
      profilePicture: data['profilePicture'],
      accountType: data['accountType'],
      gender: data['gender'],
      bio: data['bio'],
      memberSince: data['memberSince'],
      isVarified: data['isVarified'],
      // Add more properties here as needed
    );
  }
}
