import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../drawer_screen.dart';

Widget drawerIcon(BuildContext context) {
  return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Image.asset(
        'assets/drawer.png',
        color: Colors.white,
        height: 35,
      ),
      onPressed: () {
        // log("message");
        // log(provider.firebaseUser!.uid);
        // FirebaseHelper().updateUserModelWithFirebaseUser(provider);

        drawerController.toggle!();
      });
}
