import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_chat_app/constants/global_variables.dart';
import 'package:voice_chat_app/features/auth/controller/auth_controller.dart';
import 'package:voice_chat_app/widgets/custom_button.dart';
import 'package:voice_chat_app/widgets/custom_textfield.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends ConsumerStatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final Auth _auth = Auth.signin;
  // final _signUpFormKey = GlobalKey<FormState>();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _selectController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // void registerUser() {
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();
  //   String name = _nameController.text.trim();
  //   String select = _selectController.text.trim();
  //   // signup user using our authmethodds
  //   if (email.isNotEmpty || password.isNotEmpty) {
  //     ref
  //         .read(authControllerProvider)
  //         .saveSignUpUser(context, email, password, name, select);
  //   }
  // }

  void loginInUser() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // signup user using our authmethodds
    if (email.isNotEmpty || password.isNotEmpty) {
      ref.read(authControllerProvider).saveSignInUser(
            context,
            email,
            password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        body: signInAndSignUpUI(context),
      ),
    );
  }

  Widget signInAndSignUpUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "RTC APP",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        // ListTile(
        //   tileColor: _auth == Auth.signup
        //       ? GlobalVariables.backgroundColor
        //       : GlobalVariables.greyBackgroundCOlor,
        //   title: const Text(
        //     'Create Account',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   leading: Radio(
        //     activeColor: GlobalVariables.secondaryColor,
        //     value: Auth.signup,
        //     groupValue: _auth,
        //     onChanged: (Auth? value) {
        //       setState(() {
        //         _auth = value!;
        //       });
        //     },
        //   ),
        // ),
        // if (_auth == Auth.signup)
        //   Container(
        //     padding: const EdgeInsets.all(8),
        //     color: GlobalVariables.backgroundColor,
        //     child: Form(
        //       key: _signUpFormKey,
        //       child: Column(
        //         children: [
        //           const SizedBox(height: 10),
        //           CustomTextField(
        //             controller: _nameController,
        //             hintText: 'Name',
        //             textInputType: TextInputType.text,
        //           ),
        //           const SizedBox(height: 10),
        //           CustomTextField(
        //             controller: _selectController,
        //             hintText: 'Select',
        //             textInputType: TextInputType.text,
        //           ),
        //           const SizedBox(height: 10),
        //           CustomTextField(
        //             controller: _emailController,
        //             hintText: 'Email',
        //             textInputType: TextInputType.emailAddress,
        //           ),
        //           const SizedBox(height: 10),
        //           CustomTextField(
        //             controller: _passwordController,
        //             hintText: 'Password',
        //             textInputType: TextInputType.text,
        //             isPass: true,
        //           ),
        //           const SizedBox(height: 10),
        //           CustomButton(
        //             color: const Color.fromARGB(255, 241, 159, 37),
        //             text: 'Sign Up',
        //             onTap: () {
        //               if (_signUpFormKey.currentState!.validate()) {
        //                 registerUser();
        //               }
        //             },
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ListTile(
        //   tileColor: _auth == Auth.signin
        //       ? GlobalVariables.backgroundColor
        //       : GlobalVariables.greyBackgroundCOlor,
        //   title: const Text(
        //     'Sign-In.',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   leading: Radio(
        //     activeColor: GlobalVariables.secondaryColor,
        //     value: Auth.signin,
        //     groupValue: _auth,
        //     onChanged: (Auth? value) {
        //       setState(() {
        //         _auth = value!;
        //       });
        //     },
        //   ),
        // ),
        // if (_auth == Auth.signin)
        Container(
          padding: const EdgeInsets.all(20),
          color: GlobalVariables.backgroundColor,
          child: Form(
            key: _signInFormKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: CustomButton(
                    color: const Color.fromARGB(255, 241, 159, 37),
                    text: 'Sign In',
                    onTap: () {
                      if (_signInFormKey.currentState!.validate()) {
                        loginInUser();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 45,
        ),
      ],
    );
  }
}
