import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_chat_app/api/api_service.dart';
import 'package:voice_chat_app/features/auth/screens/auth.dart';
import 'package:voice_chat_app/models/login_request_model.dart';
import 'package:voice_chat_app/models/user_model.dart';
import 'package:voice_chat_app/responsive/responsive_layout.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('token');
    if (action == null) {
      return null;
    }
    var userData = await firestore.collection('users').doc(action).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  // Future<void> signUpUser({
  //   required ProviderRef ref,
  //   required BuildContext context,
  //   required String email,
  //   required String password,
  //   required String name,
  //   required String select,
  // }) async {
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty) {
  //       // register user
  //       UserCredential cred = await auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       UserModel user = UserModel(
  //         uid: cred.user!.uid,
  //         email: email,
  //         name: name,
  //         select: select,
  //       );
  //       // add user to our database
  //       await firestore
  //           .collection("users")
  //           .doc(cred.user!.uid)
  //           .set(user.toMap());
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBars(context: context, content: e.toString());
  //   }
  // }

  Future<void> signInUser({
    required ProviderRef ref,
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (email.isNotEmpty || password.isNotEmpty) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => {
              loginGetToken(value.user!.uid.toString(), context),
              prefs.setString('token', value.user!.uid.toString()),
            },
          );
    }
  }

  void loginGetToken(String uid, context) {
    LoginRequestModel model = LoginRequestModel(uid: uid);
    APIService.loginGetToken(model).then(
      (response) => {
        if (response)
          Navigator.of(context).pushNamedAndRemoveUntil(
              ResponsiveLayout.routeName, (route) => false)
      },
    );
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Future<void> setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  Future<void> signOut({required BuildContext context}) async {
    await auth.signOut().then(
          (value) => {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthScreen.routeName, (route) => false),
          },
        );
  }
}
