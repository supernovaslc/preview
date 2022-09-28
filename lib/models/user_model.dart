class UserModel {
  final String email;
  final String uid;
  final String name;
  final String select;

  const UserModel({
    required this.email,
    required this.uid,
    required this.name,
    required this.select,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? '',
      email: map["email"] ?? '',
      name: map["name"] ?? '',
      select: map["select"] ?? '',
    );
  }
}
