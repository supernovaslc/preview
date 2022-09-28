class LoginRequestModel {
  LoginRequestModel({
    required this.uid,
  });
  late final String uid;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    return data;
  }
}
