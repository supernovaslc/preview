import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:voice_chat_app/features/auth/controller/auth_controller.dart';
import 'package:voice_chat_app/features/call/screens/call_pickup_screen.dart';
import 'package:voice_chat_app/features/chat/widgets/contacts_list.dart';
import 'package:voice_chat_app/utils/colors.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen> {
  void signOutUser() async {
    ref.read(authControllerProvider).signOutUser(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // @override
  // void didChangeDependencies() {
  //   ref.watch(chatControllerProvider).chatRooms();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: blueColor,
          centerTitle: false,
          title: const Text(
            'RTC App',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Logout',
                  ),
                  onTap: () => Future(
                    () => {
                      signOutUser(),
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: const ContactsList(),
      ),
    );
  }
}
