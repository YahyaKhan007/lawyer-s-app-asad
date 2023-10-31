import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/model/models.dart';

class UserProvider extends ChangeNotifier {
  User? _firebaseUser;
  ClientModel? _clientModel;

  ClientModel? get clientModel => _clientModel;

  void updateClientUser(ClientModel? value) {
    _clientModel = value;
    notifyListeners();
    log("============================>>>     Called");
  }

  AdvocateModel? _advocateModel;

  AdvocateModel? get advocateModel => _advocateModel!;

  void updateAdvocateModel(AdvocateModel? value) {
    _advocateModel = value;
    notifyListeners();
    log("============================>>>     Called");
  }

  User? get firebaseUser => _firebaseUser!;

  void updateFirebaseUser(User value) {
    _firebaseUser = value;
    notifyListeners();
  }

  int _screenIndex = 0;
  int get screenIndex => _screenIndex;

  void changeScreenIndex(int value) {
    _screenIndex = value;
    notifyListeners();
  }

  // ~ Admin
  AdminModel? _adminModel;

  AdminModel? get adminModel => _adminModel!;

  void updateAdminModel(AdminModel? value) {
    _adminModel = value;
    notifyListeners();
    log("============================>>>     Called");
  }

// ~ changing Language
  String _langCode = 'en';
  String get langCode => _langCode;

  void changeLanguageCode(String value) {
    _langCode = value;
    notifyListeners();
  }

  String _countryCode = 'US';
  String get countryCode => _countryCode;

  void changeCountryCode(String value) {
    _countryCode = value;
    notifyListeners();
  }

  // bool _sendEmotion = false;
  // bool get sendEmotion => _sendEmotion;

  // void changeSendEmotionOption(bool value) {
  //   _sendEmotion = value;
  //   notifyListeners();
  // }
}
