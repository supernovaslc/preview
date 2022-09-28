class ChatContact {
  final String name;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact({
    required this.name,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSent: map['timeSent'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
