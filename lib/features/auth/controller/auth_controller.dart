import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_chat_app/features/auth/repository/auth_repository.dart';
import 'package:voice_chat_app/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void saveSignInUser(
    BuildContext context,
    String email,
    String password,
  ) {
    authRepository.signInUser(
      ref: ref,
      context: context,
      email: email,
      password: password,
    );
  }

  void signOutUser(BuildContext context) {
    authRepository
        .setUserState(false)
        .then((value) => {authRepository.signOut(context: context)});
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  // void saveSignUpUser(
  //   BuildContext context,
  //   String email,
  //   String password,
  //   String name,
  //   String select,
  // ) {
  //   authRepository.signUpUser(
  //     ref: ref,
  //     context: context,
  //     email: email,
  //     password: password,
  //     name: name,
  //     select: select,
  //   );
  // }
}
