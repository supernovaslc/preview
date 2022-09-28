import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_chat_app/features/call/controller/call_controller.dart';
import 'package:voice_chat_app/features/chat/controller/chat_controller.dart';
import 'package:voice_chat_app/info.dart';
import 'package:voice_chat_app/models/room_model.dart';
import 'package:voice_chat_app/utils/colors.dart';
import 'package:voice_chat_app/widgets/loader.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  void makeCall(
    WidgetRef ref,
    BuildContext context,
    name,
    uid,
  ) async {
    ref.read(callControllerProvider).makeCall(context, name, uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<RoomModel>>(
              stream: ref.watch(chatControllerProvider).chatRooms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return buildContactList(snapshot.data, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactList(List<RoomModel>? rooms, ref) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rooms?.length ?? 0,
      itemBuilder: (context, index) {
        final chatContactData = rooms?[index];
        return Column(
          children: [
            InkWell(
              onTap: () {
                makeCall(
                  ref,
                  context,
                  chatContactData?.name,
                  chatContactData?.uid,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(
                    chatContactData?.name ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      info[0]['profilePic'].toString(),
                    ),
                    radius: 30,
                  ),
                ),
              ),
            ),
            const Divider(color: dividerColor, indent: 85),
          ],
        );
      },
    );
  }

  // Future<ConfirmAction?> showMyAlertDialog(
  //   BuildContext context,
  // ) async {
  //   return showDialog<ConfirmAction>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button for close dialog!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
  //         title: const Text('Thông báo!!'),
  //         content: const SizedBox(
  //             width: 300, height: 50, child: Text('KG02 muốn kết nối với bạn')),
  //         shape: const RoundedRectangleBorder(
  //             side: BorderSide(color: Colors.grey, width: 1),
  //             borderRadius: BorderRadius.all(Radius.circular(9))),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(ConfirmAction.Cancel);
  //             },
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
  //             ),
  //             child: const Text(
  //               "CANCEL",
  //               style: TextStyle(color: chatBarMessage),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(ConfirmAction.Accept);
  //             },
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all<Color>(blueColor),
  //             ),
  //             child: const Text(
  //               "ACCEPT",
  //               style: TextStyle(color: primaryColor),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
