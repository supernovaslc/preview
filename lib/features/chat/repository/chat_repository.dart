import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_chat_app/common/enums/message_enum.dart';
import 'package:voice_chat_app/common/providers/message_reply_provider.dart';
import 'package:voice_chat_app/models/chat_contact.dart';
import 'package:voice_chat_app/models/group.dart';
import 'package:voice_chat_app/models/message.dart';
import 'package:voice_chat_app/models/room_model.dart';
import 'package:voice_chat_app/models/user_model.dart';
import 'package:voice_chat_app/utils/utils.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<Message>> getChatStream(
    String recieverUserId,
    String callerUserId,
  ) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid == callerUserId
            ? recieverUserId
            : callerUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }

      return messages;
    });
  }

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<RoomModel>> getRoomChat() {
    return firestore.collection('users').snapshots().asyncMap(
      (event) async {
        List<RoomModel> contacts = [];

        if (auth.currentUser!.uid.isNotEmpty) {
          for (var document in event.docs) {
            var chatContact = RoomModel.fromMap(document.data());
            var userData = await firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .get();
            var user = UserModel.fromMap(userData.data()!);

            if (auth.currentUser!.uid != chatContact.uid) {
              if (chatContact.select != user.select && chatContact.isOnline) {
                contacts.add(
                  RoomModel(
                    uid: chatContact.uid,
                    name: chatContact.name,
                    select: chatContact.select,
                    isOnline: chatContact.isOnline,
                  ),
                );
              }
            }
          }
        }
        return contacts;
      },
    );
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
          contactId: chatContact.contactId,
          lastMessage: chatContact.lastMessage,
          name: user.name,
          timeSent: chatContact.timeSent,
        ));
      }
      return contacts;
    });
  }

//   void saveDataToContactsSubcollection(
//     UserModel senderUserData,
//     UserModel? recieverUserData,
//     String text,
//     DateTime timeSent,
//     String recieverUserId,
//     bool isGroupChat,
//   ) async {
//     if (isGroupChat) {
//       await firestore.collection('groups').doc(recieverUserId).update({
//         'lastMessage': text,
//         'timeSent': DateTime.now().millisecondsSinceEpoch,
//       });
//     } else {
// // users -> reciever user id => chats -> current user id -> set data
//       var recieverChatContact = ChatContact(
//         name: senderUserData.name,
//         contactId: senderUserData.uid,
//         timeSent: timeSent,
//         lastMessage: text,
//       );
//       await firestore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .set(
//             recieverChatContact.toMap(),
//           );
//       // users -> current user id  => chats -> reciever user id -> set data
//       var senderChatContact = ChatContact(
//         name: recieverUserData!.name,
//         contactId: recieverUserData.uid,
//         timeSent: timeSent,
//         lastMessage: text,
//       );
//       await firestore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .set(
//             senderChatContact.toMap(),
//           );
//     }
//   }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      countMessage: 1,
      isSeen: false,
      senderName: senderUsername,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName ?? '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required String callerUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now().toUtc();
      UserModel? recieverUserData;

      // if (!isGroupChat) {
      //   var userDataMap =
      //       await firestore.collection('users').doc(recieverUserId).get();
      //   recieverUserData = UserModel.fromMap(userDataMap.data()!);
      // }

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubcollection(
        recieverUserId: auth.currentUser!.uid == callerUserId
            ? recieverUserId
            : callerUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        username: senderUser.name,
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }
}
