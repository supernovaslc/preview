import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
// part 'token.g.dart';

@freezed
class RTCTokenModel with _$RTCTokenModel {
  factory RTCTokenModel({
    required String rtcToken,
  }) = _RTCTokenModel;

  // factory RTCTokenModel.fromJson(Map<String, String> json) =>
  //     _$RTCTokenModelFromJson(json);
}
