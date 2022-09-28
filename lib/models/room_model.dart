class RoomModel {
  final String? name;
  final String? uid;
  final String? select;
  final bool isOnline;

  const RoomModel({
    required this.name,
    required this.uid,
    required this.select,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'select': select,
      'isOnline': isOnline,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      select: map['select'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }
}
