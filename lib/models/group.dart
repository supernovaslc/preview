class Group {
  final String senderId;
  final String groupId;
  final List<String> membersUid;
  final DateTime timeSent;
  Group({
    required this.senderId,
    required this.groupId,
    required this.membersUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'groupId': groupId,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] ?? '',
      groupId: map['groupId'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
