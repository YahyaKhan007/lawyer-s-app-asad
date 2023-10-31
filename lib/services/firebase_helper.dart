import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/model/advocate_model.dart';
import 'package:laywers_app/model/client_model.dart';

StreamController<ClientModel> userDataController =
    StreamController<ClientModel>();

class FirebaseHelper {
  // ! Signup Details

  // ! Login Details

  // ! Getting User By ID

  static Future<ClientModel?> getClientModelById(String uid) async {
    ClientModel? userModel;
    log("===================================>>$uid");

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("client_users")
        .doc(uid)
        .get();

    if (docSnap.data() != null) {
      userModel = ClientModel.fromMap(docSnap.data() as Map<String, dynamic>);

      log(userModel.fullName.toString());
    }

    return userModel;
  }
  // ^ For Advocate

  static Future<AdvocateModel?> geAdvocateModelById(String uid) async {
    AdvocateModel? advocateModel;
    log("===================================>>$uid");

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("advocate_users")
        .doc(uid)
        .get();

    if (docSnap.data() != null) {
      advocateModel =
          AdvocateModel.fromMap(docSnap.data() as Map<String, dynamic>);

      log(advocateModel.fullName.toString());
    }

    return advocateModel;
  }

  static Future<AdminModel?> getAdminModel() async {
    AdminModel? adminModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("admin_user")
        .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
        .get();

    if (docSnap.data() != null) {
      adminModel = AdminModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return adminModel;
  }

  // static void getUserData(String uid) async {
  //   DocumentSnapshot userSnapshot =
  //       await FirebaseFirestore.instance.collection('requests').doc(uid).get();
  //   ClientModel? clientModel;

  //   // Create a UserModel object from the retrieved user data
  //   if (userSnapshot.data() != null) {
  //     clientModel =
  //         ClientModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

  //     print(clientModel.fullName.toString());
  //   }

  //   // Add the UserModel object to the stream
  //   userDataController.add(clientModel!);
  // }
}
