import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_chat_app/common/providers/message_reply_provider.dart';
import 'package:voice_chat_app/features/chat/controller/chat_controller.dart';
import 'package:voice_chat_app/features/chat/widgets/message_reply_preview.dart';
import 'package:voice_chat_app/utils/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final String callerUserId;
  final bool isGroupChat;

  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.callerUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void sendTextMessage() async {
    if (isShowSendButton && _messageController.text.trim().isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
            widget.callerUserId,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
            Expanded(
              flex: 1,
              child: Container(
                height: 62,
                color: blueColor,
                child: InkWell(
                  onTap: () {
                    hideKeyboard();
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 500,
                          color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Modal BottomSheet'),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () {
                                  hideKeyboard();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.add_circle_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textColor,
                  // prefixIcon: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 18.0),
                  //   child: InkWell(
                  //     child: Icon(
                  //       Icons.add_circle_outline,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  // suffixIcon: SizedBox(
                  //   width: 70,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: const [
                  //       Icon(
                  //         Icons.upload_file_outlined,
                  //         color: Colors.grey,
                  //       ),
                  //       Icon(
                  //         Icons.camera_alt,
                  //         color: Colors.grey,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  // contentPadding: const EdgeInsets.all(21),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 62,
                color: blueColor,
                child: InkWell(
                  onTap: sendTextMessage,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
