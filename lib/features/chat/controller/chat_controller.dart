import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:voice_chat_app/common/providers/message_reply_provider.dart';
import 'package:voice_chat_app/features/auth/controller/auth_controller.dart';

import 'package:voice_chat_app/features/chat/repository/chat_repository.dart';
import 'package:voice_chat_app/models/chat_contact.dart';
import 'package:voice_chat_app/models/group.dart';
import 'package:voice_chat_app/models/message.dart';
import 'package:voice_chat_app/models/room_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);

  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(
    String recieverUserId,
    String callerUserId,
  ) {
    return chatRepository.getChatStream(
      recieverUserId,
      callerUserId,
    );
  }

  Stream<List<RoomModel>> chatRooms() {
    return chatRepository.getRoomChat();
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    String callerUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            callerUserId: callerUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }
}
