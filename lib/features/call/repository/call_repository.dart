import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_chat_app/models/call.dart';
import 'package:voice_chat_app/models/group.dart' as model;
import 'package:voice_chat_app/utils/utils.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    BuildContext context,
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }

  void updateMakeCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(callerId)
          .update({'joinRoom': true});
      await firestore
          .collection('call')
          .doc(receiverId)
          .update({'joinRoom': true});
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(auth.currentUser!.uid).delete();
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }

  void rejectedCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }
    } catch (e) {
      showSnackBars(context: context, content: e.toString());
    }
  }

  // void endGroupCall(
  //   String callerId,
  //   String receiverId,
  //   BuildContext context,
  // ) async {
  //   try {
  //     await firestore.collection('call').doc(callerId).delete();
  //     var groupSnapshot =
  //         await firestore.collection('groups').doc(receiverId).get();
  //     model.Group group = model.Group.fromMap(groupSnapshot.data()!);
  //     for (var id in group.membersUid) {
  //       await firestore.collection('call').doc(id).delete();
  //     }
  //   } catch (e) {
  //     showSnackBars(context: context, content: e.toString());
  //   }
  // }
}
