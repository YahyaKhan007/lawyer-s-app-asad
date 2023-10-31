import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/services/firebase_auth_controller.dart';

import '../model/models.dart';

class AdvocateProvider extends ChangeNotifier {
  var authConroller = Get.find<FirebaseAuthController>();
  // ^ Advocate User

  final List<AdvocateModel> _advocateUsers = [];
  List<AdvocateModel> get users => _advocateUsers;
  Future<List<AdvocateModel>?> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('advocate_users').get();
      _advocateUsers.clear(); // Clear the existing list.
      for (var doc in querySnapshot.docs) {
        _advocateUsers.add(AdvocateModel.fromSnapshot(doc));

        //~  ratings
        List<dynamic>? ratings = AdvocateModel.fromSnapshot(doc).ratings;
        if (ratings != null) {
          var sum = 0.0;
          var time = 0;
          for (var rating in ratings) {
            if (rating.runtimeType == double) {
              sum = sum + rating;
              time += 1;
            } else if (rating.runtimeType == int) {
              sum = sum + rating;
              time += 1;
            }
          }

          authConroller.avgRatingCalculator(times: time, value: sum);
        }

        // ~ ************************
      }
      notifyListeners();
      return _advocateUsers;
    } catch (e) {
      log('Error fetching users: $e');
      return null;
    }
  }

  // ^ Client User

  final List<ClientModel> _clientUsers = [];
  List<ClientModel> get clientUsers => _clientUsers;
  Future<List<ClientModel>?> getAllClientUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('client_users').get();
      _clientUsers.clear(); // Clear the existing list.
      for (var doc in querySnapshot.docs) {
        _clientUsers.add(ClientModel.fromSnapshot(doc));
      }
      notifyListeners();
      return _clientUsers;
    } catch (e) {
      log('Error fetching users: $e');
      return null;
    }
  }

  AdminModel? _adminModel;
  AdminModel? get adminModel => _adminModel;
  geAdminModel() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("admin_user")
          .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
          .get();

      AdminModel adminModel =
          AdminModel.fromMap(userData.data() as Map<String, dynamic>);

      _adminModel = adminModel;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
