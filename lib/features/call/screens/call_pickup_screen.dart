import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_chat_app/config/agora_config.dart';

import 'package:voice_chat_app/features/call/controller/call_controller.dart';
import 'package:voice_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:voice_chat_app/models/call.dart';

class CallPickupScreen extends ConsumerStatefulWidget {
  final Widget scaffold;

  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  ConsumerState<CallPickupScreen> createState() => _CallPickupState();
}

class _CallPickupState extends ConsumerState<CallPickupScreen> {
  Timer? timer;
  late final RtcEngine _engine;
  bool muted = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
    _engine.destroy();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    addListeners();
  }

  Future<void> _initAgoraRtcEngine() async {
    // _engine = await RtcEngine.createWithContext(RtcEngineContext(
    //   AgoraConfig.appId,
    // ));
    _engine = await RtcEngine.create(AgoraConfig.appId);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
        warning: (warningCode) {},
        error: (errorCode) {},
        joinChannelSuccess: (chanel, uid, elapsed) {},
        leaveChannel: (state) {},
        tokenPrivilegeWillExpire: (token) async {
          await _engine.renewToken(token);
        }));
  }

  Future<void> toggleAudio() async {
    setState(() {
      muted = !muted;
    });
    await _engine.muteLocalAudioStream(muted);
  }

  Future<void> joinChannel(
    String rtcToken,
    String rtcChanel,
    String receiverId,
    String callerId,
  ) async {
    if (rtcToken != '') {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Permission.microphone.request();
      }
      await _engine
          .joinChannel(rtcToken, rtcChanel, null, 0)
          .catchError((onError) {});
    }
    stopTimer();
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          Call call =
              Call.fromMap(snapshot.data?.data() as Map<String, dynamic>);
          if (call.joinRoom) {
            joinChannel(
              call.token,
              call.chanelId,
              call.receiverId,
              call.callerId,
            );
            return MobileChatScreen(
              call: call,
              ref: ref,
              engine: _engine,
              toggleAudio: toggleAudio,
              audio: muted,
            );
          } else {
            if (!call.hasDialled) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Incoming Call',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              autoCallEnd(ref, call, context);
                            },
                            icon: const Icon(Icons.call_end,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(width: 25),
                          IconButton(
                            onPressed: () {
                              ref.read(callControllerProvider).updateMakeCall(
                                    context,
                                    call.callerId,
                                    call.receiverId,
                                  );
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              timer = Timer(const Duration(seconds: 15),
                  () => {autoCallEnd(ref, call, context)});
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Thông báo!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Xin đợi một chút',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        }

        return widget.scaffold;
      },
    );
  }

  autoCallEnd(ref, call, context) {
    ref.read(callControllerProvider).rejectedCall(
          call?.callerId,
          call?.receiverId,
          context,
        );
  }
}
