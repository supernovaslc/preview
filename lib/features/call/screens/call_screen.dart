// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// // import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
// // import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:voice_chat_app/config/agora_config.dart';
// import 'package:voice_chat_app/models/call.dart';
// import 'package:voice_chat_app/utils/colors.dart';

// class CallScreen extends StatefulWidget {
//   static const String routeName = '/call-screen';

//   final String channelId;
//   final Call call;

//   const CallScreen({
//     Key? key,
//     required this.call,
//     required this.channelId,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _State();
// }

// class _State extends State<CallScreen> {
//   late final RtcEngine _engine;
//   String channelId = AgoraConfig.chanel;
//   bool isJoined = false,
//       openMicrophone = true,
//       enableSpeakerphone = true,
//       playEffect = false;

//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: channelId);
//     _initEngine();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _engine.destroy();
//   }

//   _initEngine() async {
//     _engine =
//         await RtcEngine.createWithContext(RtcEngineContext(AgoraConfig.appId));
//     _addListeners();

//     await _engine.enableAudio();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setClientRole(ClientRole.Broadcaster);
//   }

//   void _addListeners() {
//     _engine.setEventHandler(RtcEngineEventHandler(
//       warning: (warningCode) {},
//       error: (errorCode) {},
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           isJoined = true;
//         });
//       },
//       leaveChannel: (stats) async {
//         setState(() {
//           isJoined = false;
//         });
//       },
//     ));
//   }

//   _joinChannel() async {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await Permission.microphone.request();
//     }
//     await _engine
//         .joinChannel(AgoraConfig.token, _controller.text, null, 0)
//         .catchError((onError) {});
//   }

//   _leaveChannel() async {
//     await _engine.leaveChannel();
//     setState(() {
//       isJoined = false;
//       openMicrophone = true;
//       enableSpeakerphone = true;
//       playEffect = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: blueColor,
//         title: const Text(
//           '',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_outlined),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Colors.white,
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(hintText: 'Channel ID'),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ElevatedButton(
//                       onPressed: isJoined ? _leaveChannel : _joinChannel,
//                       child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
