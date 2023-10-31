import 'package:cloud_firestore/cloud_firestore.dart';

class AdvocateModel {
  List<dynamic>? ratings;
  String? uid;
  String? fullName;
  String? email;
  String? pushToken;
  String? profilePicture;
  String? accountType;
  String? gender;
  String? bio;
  Timestamp? memberSince;
  bool? isVarified;
  List<dynamic>? ratedFrom;
// ! simple Constructor
  AdvocateModel({
    required this.uid,
    // required this.sendEmotion,
    required this.fullName,
    required this.email,
    required this.bio,
    required this.gender,
    required this.ratings,
    required this.ratedFrom,
    // required this.sender,
    // required this.reciever,
    // required this.friends,
    required this.memberSince,
    required this.accountType,
    required this.pushToken,
    required this.isVarified,
    required this.profilePicture,
  });

//  !  will be Used to change your Map/Json data into UserModel
  AdvocateModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    gender = map["gender"];
    memberSince = map["memberSince"];
    pushToken = map["pushToken"];
    accountType = map["accountType"];
    isVarified = map['isVarified'];
    profilePicture = map["profilePicture"];
    bio = map["bio"];
    ratings = map["ratings"];
    ratedFrom = map["ratedFrom"];
  }

//  !  will be Used to change your UserModel object into Map/Json
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "gender": gender,
      "memberSince": memberSince,
      "accountType": accountType,
      "profilePicture": profilePicture,
      "pushToken": pushToken,
      'isVarified': isVarified,
      "bio": bio,
      "ratings": ratings,
      "ratedFrom": ratedFrom,
    };
  }

  factory AdvocateModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return AdvocateModel(
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
      ratedFrom: data['ratedFrom'],
      ratings: (data["ratings"]),
      // as List<dynamic>?)?.cast<double>(),

      // Add more properties here as needed
    );
  }
}
