import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_chat_app/features/call/controller/call_controller.dart';
import 'package:voice_chat_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:voice_chat_app/features/chat/widgets/chat_list.dart';
import 'package:voice_chat_app/models/call.dart';
import 'package:voice_chat_app/utils/colors.dart';

class MobileChatScreen extends StatelessWidget {
  final Call call;
  final WidgetRef ref;
  final RtcEngine engine;
  final Function toggleAudio;
  final bool audio;

  const MobileChatScreen({
    Key? key,
    required this.call,
    required this.ref,
    required this.engine,
    required this.toggleAudio,
    required this.audio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    leaveChannel() async {
      ref.read(callControllerProvider).endCall(
            call.callerId,
            call.receiverId,
            context,
          );
      await engine.leaveChannel();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          call.receiverName,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            toggleAudio();
          },
          icon: audio ? const Icon(Icons.mic) : const Icon(Icons.mic_off),
          color: Colors.white,
          padding: const EdgeInsets.all(18.0),
        ),
        actions: [
          IconButton(
            onPressed: () {
              leaveChannel();
            },
            icon: const Icon(Icons.call_end),
            color: Colors.white,
            padding: const EdgeInsets.all(18.0),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              isGroupChat: false,
              recieverUserId: call.receiverId,
              callerUserId: call.callerId,
            ),
          ),
          BottomChatField(
            isGroupChat: false,
            recieverUserId: call.receiverId,
            callerUserId: call.callerId,
          )
        ],
      ),
    );
  }
}
