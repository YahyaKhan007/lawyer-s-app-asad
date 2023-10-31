import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class LangController extends GetxController {
  // ~ Change Locale
  changeLocal({required String langCode, required String countryCode}) {
    var locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);

    prefs!.setString('Language_Code', langCode);
    prefs!.setString('Country_Code', countryCode);
  }

  // @override
  // void onInit() {
  //   changeLocal(langCode: langCode, countryCode: countryCode);
  //   super.onInit();
  // }
}
