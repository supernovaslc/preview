import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:voice_chat_app/features/chat/controller/chat_controller.dart';
import 'package:voice_chat_app/features/chat/widgets/my_message_card.dart';
import 'package:voice_chat_app/features/chat/widgets/sender_message_card.dart';
import 'package:voice_chat_app/models/message.dart';
import 'package:voice_chat_app/widgets/loader.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final String callerUserId;
  final bool isGroupChat;

  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.callerUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref
          .read(chatControllerProvider)
          .chatStream(widget.recieverUserId, widget.callerUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final messageData = snapshot.data?[index];
            var timeSent = DateFormat.Hm().format(messageData!.timeSent);

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              senderName: messageData.senderName,
              date: timeSent,
            );
          },
        );
      },
    );
  }
}
