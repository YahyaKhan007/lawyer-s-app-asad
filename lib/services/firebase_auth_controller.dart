// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laywers_app/main.dart';
import 'package:laywers_app/model/adminModel.dart';
import 'package:laywers_app/model/models.dart';
import 'package:laywers_app/model/rating_model.dart';
import 'package:laywers_app/services/loading_provider.dart';
import 'package:laywers_app/services/user_provider.dart';
import 'package:laywers_app/view/screens.dart';
import 'package:image_cropper/image_cropper.dart';

class FirebaseAuthController extends GetxController {
  var screenIndex = 2.obs;
  var isLoading = false.obs;
  var isOpen = false.obs;
  var showPassword = true.obs;
  var whereToGo = 'login'.obs;
  final Rx<File?> image = Rx<File?>(null);

  var pending = true.obs;

  var english = "English".obs;
  var urdu = "Urdu".obs;
  var hindhi = "Hindhi".obs;

  changeStatus({required String go}) {
    whereToGo.value = go;
    getBox.write('whereToGo', go);

    update();
    log(getBox.read('whereToGo'));
  }

  changeScreenIndex({required int index}) {
    screenIndex.value = index;
    update();
  }

  var clientModel = ClientModel(
          uid: null,
          fullName: "",
          email: "",
          bio: "",
          memberSince: Timestamp.now(),
          accountType: "",
          pushToken: "",
          isVarified: false,
          profilePicture: "",
          gender: '')
      .obs;

  // ~ Signup user function
  signupUser({
    required String email,
    required String password,
    required String accountType,
    required UserProvider userProvider,
  }) async {
    try {
      isLoading.value = true;
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password.toString());

      String uid = credential.user!.uid;

      if (accountType == 'Client') {
        ClientModel newUser = ClientModel(
            gender: selectGender.value,
            uid: uid,
            fullName: "",
            email: email,
            profilePicture: "",
            accountType: "Client User",
            bio: "",
            pushToken: "",
            memberSince: Timestamp.now(),
            isVarified: true);

        await FirebaseFirestore.instance
            .collection("client_users")
            .doc(uid)
            .set(
              newUser.toMap(),
            )
            .then((value) => updateUser(newUser: newUser))
            .then((value) => userProvider.updateClientUser(newUser))
            .then((value) => userProvider.updateFirebaseUser(
                  FirebaseAuth.instance.currentUser!,
                ))
            .then((value) => isLoading.value = false)
            .then(
              (value) => Get.offAll(
                  () => CompleteProfile(
                        firebaseUser: FirebaseAuth.instance.currentUser!,
                        clientModel: newUser,
                        advocateModel: null,
                      ),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 500)),
            );
      } else if (accountType == 'Advocate') {
        AdvocateModel newUser = AdvocateModel(
            gender: selectGender.value,
            uid: uid,
            fullName: "",
            email: email,
            profilePicture: "",
            accountType: "Advocate User",
            bio: "",
            pushToken: "",
            // ratings: [],
            memberSince: Timestamp.now(),
            isVarified: false,
            ratings: [],
            ratedFrom: []);

        await FirebaseFirestore.instance
            .collection("advocate_users")
            .doc(uid)
            .set(
              newUser.toMap(),
            )
            // .then((value) => updateUser(newUser: newUser))
            .then((value) => userProvider.updateAdvocateModel(newUser))
            .then((value) => userProvider.updateFirebaseUser(
                  FirebaseAuth.instance.currentUser!,
                ))
            .then((value) => isLoading.value = false)
            .then(
              (value) => Get.offAll(
                  () => CompleteProfile(
                        firebaseUser: FirebaseAuth.instance.currentUser!,
                        clientModel: null,
                        advocateModel: newUser,
                      ),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 500)),
            );
      }
    } on FirebaseException {
      isLoading.value = false;

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 1),
        message: "try another email".tr,
      ));
    }
  }

  // ~ Login Function
  loginUser({
    required String email,
    required String password,
    required String type,
    required UserProvider userProvider,
  }) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.toString(), password: password.toString());

      String uid = userCredential.user!.uid;

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // ^ Client User
        // ~ Client User
        // ? Client User
        // ! Client User

        if (type == 'Client User') {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection("client_users")
              .doc(uid)
              .get();

          ClientModel clientModel =
              ClientModel.fromMap(userData.data() as Map<String, dynamic>);

          userProvider.updateClientUser(clientModel);
          userProvider.updateFirebaseUser(currentUser);

          Get.showSnackbar(GetSnackBar(
            message: "User Logged in".tr,
            duration: const Duration(seconds: 1),
          ));

          Get.offAll(() => MyHomePage(clientModel: userProvider.clientModel!),
              transition: Transition.rightToLeftWithFade,
              duration: const Duration(milliseconds: 500));
        }
        // ^ Advocate User
        // ~ Advocate User
        // ? Advocate User
        // ! Advocate Userelse
        else if (selectAccountType.value == 'Advocate') {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection("advocate_users")
              .doc(uid)
              .get();

          AdvocateModel advocateModel =
              AdvocateModel.fromMap(userData.data() as Map<String, dynamic>);

          userProvider.updateAdvocateModel(advocateModel);
          userProvider.updateFirebaseUser(currentUser);

          Get.showSnackbar(GetSnackBar(
            message: "User Logged in".tr,
            duration: const Duration(seconds: 1),
          ));

          Get.offAll(
              LawyerHomepage(advocateModel: advocateModel, user: currentUser),
              transition: Transition.rightToLeftWithFade,
              duration: const Duration(milliseconds: 500));
        } else {}
      }

// ! *****************************************

      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;

      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 1),
          message: 'Resolve the Issue'.tr,
        ),
      );

      return false;
    }
  }

  // ~ admin SIgnup
  adminSignup(
      {required String email,
      required String password,
      required Loading loading,
      required String confirmPassword}) async {
    try {
      if (password == confirmPassword) {
        loading.changeLoading(status: true);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String uid = userCredential.user!.uid;

        AdminModel adminModel =
            AdminModel(pending: [], accepted: [], rejected: []);

        await FirebaseFirestore.instance.collection("admin_user").doc(uid).set(
              adminModel.toMap(),
            );

        loading.changeLoading(status: false);

        Get.off(() => AdminHomePage(
              adminModel: adminModel,
            ));
      } else {
        Get.snackbar(
            "Password Miss Matched", 'Both the Passwords should match');
        loading.changeLoading(status: false);
      }
    } catch (e) {
      Get.snackbar("title", e.toString());
      loading.changeLoading(status: false);
    }
  }

// ~ adminLogin
  adminLogin(
      {required String email,
      required String password,
      required UserProvider userProvider}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.toString(), password: password.toString());

    String uid = userCredential.user!.uid;

    User? currentUser = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("admin_user")
        .doc(uid)
        .get();

    AdminModel adminModel =
        AdminModel.fromMap(userData.data() as Map<String, dynamic>);

    userProvider.updateAdminModel(adminModel);
    userProvider.updateFirebaseUser(currentUser!);
  }

// ~  User Signout Function
  signoutUser() async {
    isLoading.value = true;
    await FirebaseAuth.instance.signOut();
    isLoading.value = false;

    Get.offAll(() => const Login());
    whereToGo.value = 'login';
    Get.snackbar(
      "Sign Out".tr,
      "User has been SignOut!".tr,
    );
    // Get.showSnackbar(const GetSnackBar(
    //   title: "Sign Out",
    //   message: "User has been SignOut!",
    //   duration: Duration(seconds: 1),
    //   snackPosition: SnackPosition.TOP,
    // ));
    // "Sign Out", "User has been SignOut!"));
  }

  // ~ update user function
  // ~ update user function
  updateUser({required ClientModel newUser}) {
    try {
      log("Email of the new User ${newUser.email}");
      clientModel.value = newUser; //
      update();
      //  Set the clientModel here
      if (clientModel.value.email != "") {
        log("Client Model not Emoty ---->  ${clientModel.value.email.toString()}");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ~ Check Values
  void checkValues(
      {required BuildContext context,
      required ClientModel? clientModel,
      required UserProvider userProvider,
      required AdvocateModel? advocateModel,
      required String fullName,
      required String bio}) {
    if (fullName == "" || image.value == null || bio == ""
        // ||
        // token == ""
        ) {
      Get.snackbar("Missing Fields".tr, "Entered all the data".tr);
    } else {
      uploadProfileData(
          advocateModel: advocateModel,
          clientModel: clientModel,
          userProvider: userProvider,
          image: image.value!,
          context: context,
          name: fullName,
          bio: bio);
    }
  }

  // ~ Upload Data
  uploadProfileData(
      {required ClientModel? clientModel,
      required UserProvider userProvider,
      required AdvocateModel? advocateModel,
      required File image,
      required String name,
      required String bio,
      required BuildContext context}) async {
    try {
      isLoading.value = true;
      update();

// !  **************************8
// ^ for Client
      if (clientModel != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilePictures")
            .child(clientModel.uid.toString())
            .putFile(image);

        TaskSnapshot snapshot = await uploadTask;

        // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
        String imageUrl = await snapshot.ref.getDownloadURL();

        clientModel.fullName = name.toString();

        clientModel.bio = bio.toString();

        clientModel.profilePicture = imageUrl;

        clientModel.accountType = "Client";
        // widget.userModel.pushToken = token!;

        await FirebaseFirestore.instance
            .collection("client_users")
            .doc(clientModel.uid!)
            .set(clientModel.toMap())
            .then((value) =>
                userProvider.updateClientUser(userProvider.clientModel))
            .then((value) =>
                userProvider.updateFirebaseUser(userProvider.firebaseUser!))
            .then((value) => isLoading.value = false)
            .then((value) => Get.offAll(
                  () => MyHomePage(clientModel: userProvider.clientModel!),
                ));
      }

      // ^ For Advocate
      else if (advocateModel != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilePictures")
            .child(advocateModel.uid.toString())
            .putFile(image);

        TaskSnapshot snapshot = await uploadTask;

        // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
        String imageUrl = await snapshot.ref.getDownloadURL();

        advocateModel.fullName = name.toString();

        advocateModel.bio = bio.toString();

        advocateModel.profilePicture = imageUrl;
        advocateModel.gender = selectGender.value;

        advocateModel.accountType = "Advocate";
        // widget.userModel.pushToken = token!;

        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection("admin_user")
            .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
            .get();

        AdminModel adminModel =
            AdminModel.fromMap(userData.data() as Map<String, dynamic>);

        adminModel.pending!.add(advocateModel.uid);

        await FirebaseFirestore.instance
            .collection('admin_user')
            .doc('pdGblqNgAThCuh97T3C0DC2rKD33')
            .set(adminModel.toMap());
        userProvider.updateAdminModel(adminModel);

        await FirebaseFirestore.instance
            .collection("advocate_users")
            .doc(advocateModel.uid!)
            .set(advocateModel.toMap())
            .then((value) => userProvider.updateAdvocateModel(advocateModel))
            .then((value) =>
                userProvider.updateFirebaseUser(userProvider.firebaseUser!))
            .then((value) => isLoading.value = false)
            .then((value) => Get.offAll(
                  () => LawyerHomepage(
                    advocateModel: userProvider.advocateModel!,
                    user: userProvider.firebaseUser!,
                  ),
                ));
      }

// ! ***************************8

      isLoading.value = false;
      update();
      Get.snackbar(
          "Profile Created".tr, "Profile has been Successfully created".tr);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

// ~ **********
  showValue() {
    if (clientModel.value.email != "") {
      log("Client Model email value  ---->  ${clientModel.value.email.toString()}");
    }

    log("empty");
  }

//  ~ change show password
  changeShowPassword({required bool condition}) {
    showPassword.value = condition;

    update();
  }

// ~ Gender Type
  var genderTypes = [
    'Male',
    'Female',
  ].obs;

  RxString selectGender = 'Male'.obs;

  changegender({required String gender}) {
    selectGender.value = gender;
    update();
  }

// ~ Account Type
  var accountTypes = ['Client User', 'Advocate', 'Admin'].obs;

  RxString selectAccountType = 'Client User'.obs;

  changeAccountType({required String type}) {
    selectAccountType.value = type;
    update();
  }

  // ^ showPhotoOption
  showPhotoOption() {
    Get.defaultDialog(
      title: "Choose Photo".tr,
      titleStyle: GoogleFonts.blackOpsOne(
        fontSize: 20.sp,
        // textStyle: Theme.of(context).textTheme.bodyMedium,
        decorationColor: Colors.black,
        // backgroundColor: Colors.grey.shade100,
        color: Colors.blue,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          onTap: () {
            selectImage(imageSource: ImageSource.gallery);
            Get.back();
          },
          title: Text(
            "Select from Gallery".tr,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
          leading: const Icon(
            Icons.photo_album,
            color: Colors.blue,
          ),
        ),
        ListTile(
          onTap: () {
            selectImage(imageSource: ImageSource.camera);

            Get.back();
          },
          title: Text(
            "Take a Photo".tr,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
          leading: const Icon(
            Icons.camera,
            color: Colors.blue,
          ),
        ),
      ]),
    );
  }

  // ^ Select Image
  selectImage({required ImageSource imageSource}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
      log('Picture has been taken');
      // ! we are cropping the image now
      // cropImage(pickedFile);
    }
  }

  // ^ Crop the image here
  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      // ! we need "a value of File Type" so here we are converting the from CropperdFile to File
      final File croppedFile = File(
        croppedImage.path,
      );
// ~ image value updated
      image.value = croppedFile;
      log("Image value updated");
    }
  }

// ~ Upload Data to firebase profile
  void changeProfleData(
      {required TextEditingController nameController,
      required TextEditingController bioController,
      required BuildContext context,
      required UserProvider userModelProvider}) async {
    // var provider = Provider.of<LoadingProvider>(context, listen: false);
    try {
      isLoading.value = true;
      var imageUrl = ''.obs;
      log(image.value.toString());
      if (image.value != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilePictures")
            .child(userModelProvider.clientModel!.uid.toString())
            .putFile(image.value!);

        TaskSnapshot snapshot = await uploadTask;

        // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
        imageUrl.value = await snapshot.ref.getDownloadURL();
      }
      log("came 1");

      String? fullName = nameController.text;
      String? bio = bioController.text;

      userModelProvider.clientModel!.fullName = fullName.toString();
      userModelProvider.clientModel!.bio = bio.toString();

      log("came 2");
      if (image.value != null) {
        userModelProvider.clientModel!.profilePicture = imageUrl.value;
      }

      log("came 3");

      userModelProvider.updateClientUser(userModelProvider.clientModel);
      log("came 4");

      // widget.userModel.pushToken = token!;

      await FirebaseFirestore.instance
          .collection("client_users")
          .doc(userModelProvider.clientModel!.uid!)
          .set(userModelProvider.clientModel!.toMap())
          .then((value) =>
              Get.snackbar("Sucessful", "Profile Update Successfull"))
          .then((value) => isLoading.value = false)
          .then((value) => log("came 5"));

      Navigator.pop(context);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "There has been some issue while Updating Profile");
    }
  }

// ~ Upload Data to firebase profile advocate
  void changeAdvocateProfleData(
      {required TextEditingController nameController,
      required TextEditingController bioController,
      required BuildContext context,
      required UserProvider userProvider,
      required AdvocateModel advocateModel}) async {
    // var provider = Provider.of<LoadingProvider>(context, listen: false);
    try {
      isLoading.value = true;
      var imageUrl = ''.obs;
      log(image.value.toString());
      if (image.value != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilePictures")
            .child(advocateModel.uid.toString())
            .putFile(image.value!);

        TaskSnapshot snapshot = await uploadTask;

        // ! we need imageUrl of the profile photo inOrder to Upload it on FirebaseFirestore
        imageUrl.value = await snapshot.ref.getDownloadURL();
      }
      log("came 1");

      String? fullName = nameController.text;
      String? bio = bioController.text;

      advocateModel.fullName = fullName.toString();
      advocateModel.bio = bio.toString();

      log("came 2");
      if (image.value != null) {
        advocateModel.profilePicture = imageUrl.value;
      }

      log("came 3");

      log("came 4");

      // widget.userModel.pushToken = token!;

      await FirebaseFirestore.instance
          .collection("advocate_users")
          .doc(advocateModel.uid!)
          .set(advocateModel.toMap())
          .then((value) =>
              Get.snackbar("Sucessful", "Profile Update Successfull"))
          .then((value) => isLoading.value = false)
          .then((value) => log("came 5"));
      userProvider.updateAdvocateModel(advocateModel);
      Get.back();

      // Get.offAll(() => AdvocateProfile(userProvider: userProvider));
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "There has been some issue while Updating Profile");
    }
  }

// ~ rate the Advocate
  var rate = 0.0.obs;

  void ratetheAdvocate(
      {required AdvocateModel advocateModel,
      required UserProvider userProvider}) async {
    // advocateModel.ratings!.add(rate.value);
    isLoading.value = true;
    advocateModel.ratedFrom!.add(FirebaseAuth.instance.currentUser!.uid);
    advocateModel.ratings!.add(rate.value);

    FirebaseFirestore.instance
        .collection("advocate_users")
        .doc(advocateModel.uid)
        .set(advocateModel.toMap())
        .then((value) => Get.snackbar(
            "Thanks for rating the user", "Your rating was ${rate.value}"))
        .then((value) => isLoading.value = false);

    userProvider.updateAdvocateModel(advocateModel);
  }

  final RxList<RatingModel?> ratingList = <RatingModel?>[].obs;
  var clientList = [].obs;

  var isVisible = true.obs;
  var ratingController = TextEditingController().obs;
  void addUserRatings({required RatingModel ratingModel}) {
    ratingList.add(ratingModel);
    update();
  }

  // ~ advocate rating list etc
  var averageRating = [].obs;
  var advocateratings = [].obs;
  void avgRatingCalculator({required int times, required value}) {
    var avg = value / times;
    advocateratings.add(avg);
    averageRating.add(avg);

    update();
  }

  // ~ Workers
  @override
  void onInit() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        log("User Logged in Already");
        log(clientModel.value.email.toString());
        getBox.write('login', true);
      } else {
        log("User not Logged in");

        getBox.write('login', false);
      }
    } catch (e) {
      log(e.toString());
    }

    super.onInit();
  }
}
