class Call {
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final String chanelId;
  final bool hasDialled;
  final bool joinRoom;
  final String token;

  Call({
    required this.callerId,
    required this.callerName,
    required this.receiverId,
    required this.receiverName,
    required this.chanelId,
    required this.hasDialled,
    required this.joinRoom,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'chanelId': chanelId,
      'hasDialled': hasDialled,
      'joinRoom': joinRoom,
      'token': token,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      chanelId: map['chanelId'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
      joinRoom: map['joinRoom'] ?? false,
      token: map['token'] ?? '',
    );
  }
}
