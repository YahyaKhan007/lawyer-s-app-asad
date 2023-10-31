import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laywers_app/controller_bindings.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/services/loading_provider.dart';
import 'package:laywers_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/screens.dart';
import 'firebase_options.dart';
import 'package:uuid/uuid.dart';

SharedPreferences? prefs;
var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  User? currentUser = FirebaseAuth.instance.currentUser;
  ClientModel? thisClientModel;
  AdvocateModel? thisAdvocateModel;
  AdminModel? thisAdminModel;
  prefs = await SharedPreferences.getInstance();
  if (prefs!.getString('Language_Code') == null) {
    prefs!.setString('Country_Code', 'US');
    prefs!.setString('Language_Code', 'en');
  }

  log(prefs!.hashCode.toString());
  log(prefs!.getString("Country_Code").toString());
  log(prefs!.getString("Language_Code").toString());
  if (currentUser != null) {
    thisClientModel = await FirebaseHelper.getClientModelById(currentUser.uid);
    thisAdvocateModel =
        await FirebaseHelper.geAdvocateModelById(currentUser.uid);
    thisAdminModel = await FirebaseHelper.getAdminModel();
  }

  runApp(
    //

    ScreenUtilInit(
        designSize: const Size(350, 690),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MyApp(
            advocateModel: thisAdvocateModel,
            prefs: prefs!,
            adminModel: thisAdminModel,
            clientModel: thisClientModel,
            firebaseUser: currentUser,
          );
        }),
  );
}

var getBox = GetStorage();

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key,
      required this.clientModel,
      required this.firebaseUser,
      required this.advocateModel,
      required this.prefs,
      required this.adminModel});

  final ClientModel? clientModel;
  final AdvocateModel? advocateModel;
  final AdminModel? adminModel;
  final SharedPreferences prefs;
  final User? firebaseUser;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      String langCode = prefs!.getString("Language_Code") ?? 'en';
      String countryCode = prefs!.getString("Country_Code") ?? 'US';
      Get.updateLocale(Locale(langCode, countryCode));
      var firebaseController = Get.find<FirebaseAuthController>();
      if (countryCode == 'US') {
        firebaseController.english.value = "English";
        firebaseController.urdu.value = "";
        firebaseController.hindhi.value = "";
      } else if (countryCode == 'PK') {
        firebaseController.english.value = "";
        firebaseController.urdu.value = "Urdu";
        firebaseController.hindhi.value = "";
      } else {
        firebaseController.english.value = "";
        firebaseController.urdu.value = "";
        firebaseController.hindhi.value = "Hindhi";
      }
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // getBox.write('whereToGo', 'signup');
    // bool isLoggedIn = getBox.read('login');

    return MultiProvider(
      providers: [
        ListenableProvider(create: (_) => UserProvider()),
        ListenableProvider(create: (_) => AdvocateProvider()),
        ListenableProvider(create: (_) => Loading()),
      ],
      child: GetMaterialApp(
          initialBinding: ControllerBinding(),
          debugShowCheckedModeBanner: false,
          translations: LanguageStrings(),
          locale: Locale(widget.prefs.getString('Country_Code')!,
              widget.prefs.getString('Language_Code')!),
          fallbackLocale: Locale(widget.prefs.getString('Country_Code')!,
              widget.prefs.getString('Language_Code')!),

          // initialRoute: 'homepage',
          // getPages: [
          //   GetPage(name: '/homepage', page: () => const HomePage()),
          //   GetPage(name: '/counterAppPage', page: () => CounterApp()),
          //   GetPage(name: '/addTeacher', page: () => const AddTeacher()),
          //   GetPage(name: '/changeLanguage', page: () => ChangeLanguage()),
          //   GetPage(
          //       name: '/thirdPage',
          //       page: () => const ThirdPage(
          //             must: "khan",
          //           )),
          // ],
          // unknownRoute: GetPage(name: '/unknown', page: () => const Unknown()),

          title: "Lawyer's App".tr,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(
            adminModel: widget.adminModel,
            advocateModel: widget.advocateModel,
            clientModel: widget.clientModel,
            firebaseUser: widget.firebaseUser,
          )),
    );
  }
}
