import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_chat_app/api/api_service.dart';
import 'package:voice_chat_app/features/auth/controller/auth_controller.dart';

import 'package:voice_chat_app/features/call/repository/call_repository.dart';
import 'package:voice_chat_app/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
  ) async {
    String chanelId = const Uuid().v1();

    Future createOrderMessage() {
      final order = ref.watch(apiService).getRtcToken(chanelId, 0);
      return order;
    }

    String rtcToken = await createOrderMessage();

    ref.read(userDataAuthProvider).whenData((value) {
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        receiverId: receiverUid,
        receiverName: receiverName,
        chanelId: chanelId,
        hasDialled: true,
        token: rtcToken,
        joinRoom: false,
      );

      Call receiverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        receiverId: receiverUid,
        receiverName: receiverName,
        chanelId: chanelId,
        hasDialled: false,
        joinRoom: false,
        token: rtcToken,
      );

      if (rtcToken.isNotEmpty) {
        callRepository.makeCall(
          context,
          senderCallData,
          receiverCallData,
        );
      }
    });
  }

  void updateMakeCall(
    BuildContext context,
    String callerId,
    String receiverUid,
  ) {
    callRepository.updateMakeCall(
      context,
      callerId,
      receiverUid,
    );
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(
      callerId,
      receiverId,
      context,
    );
  }

  void rejectedCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.rejectedCall(
      callerId,
      receiverId,
      context,
    );
  }
}
