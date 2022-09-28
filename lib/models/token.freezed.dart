// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RTCTokenModel {
  String get rtcToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RTCTokenModelCopyWith<RTCTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RTCTokenModelCopyWith<$Res> {
  factory $RTCTokenModelCopyWith(
          RTCTokenModel value, $Res Function(RTCTokenModel) then) =
      _$RTCTokenModelCopyWithImpl<$Res>;
  $Res call({String rtcToken});
}

/// @nodoc
class _$RTCTokenModelCopyWithImpl<$Res>
    implements $RTCTokenModelCopyWith<$Res> {
  _$RTCTokenModelCopyWithImpl(this._value, this._then);

  final RTCTokenModel _value;
  // ignore: unused_field
  final $Res Function(RTCTokenModel) _then;

  @override
  $Res call({
    Object? rtcToken = freezed,
  }) {
    return _then(_value.copyWith(
      rtcToken: rtcToken == freezed
          ? _value.rtcToken
          : rtcToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_RTCTokenModelCopyWith<$Res>
    implements $RTCTokenModelCopyWith<$Res> {
  factory _$$_RTCTokenModelCopyWith(
          _$_RTCTokenModel value, $Res Function(_$_RTCTokenModel) then) =
      __$$_RTCTokenModelCopyWithImpl<$Res>;
  @override
  $Res call({String rtcToken});
}

/// @nodoc
class __$$_RTCTokenModelCopyWithImpl<$Res>
    extends _$RTCTokenModelCopyWithImpl<$Res>
    implements _$$_RTCTokenModelCopyWith<$Res> {
  __$$_RTCTokenModelCopyWithImpl(
      _$_RTCTokenModel _value, $Res Function(_$_RTCTokenModel) _then)
      : super(_value, (v) => _then(v as _$_RTCTokenModel));

  @override
  _$_RTCTokenModel get _value => super._value as _$_RTCTokenModel;

  @override
  $Res call({
    Object? rtcToken = freezed,
  }) {
    return _then(_$_RTCTokenModel(
      rtcToken: rtcToken == freezed
          ? _value.rtcToken
          : rtcToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_RTCTokenModel implements _RTCTokenModel {
  _$_RTCTokenModel({required this.rtcToken});

  @override
  final String rtcToken;

  @override
  String toString() {
    return 'RTCTokenModel(rtcToken: $rtcToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RTCTokenModel &&
            const DeepCollectionEquality().equals(other.rtcToken, rtcToken));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(rtcToken));

  @JsonKey(ignore: true)
  @override
  _$$_RTCTokenModelCopyWith<_$_RTCTokenModel> get copyWith =>
      __$$_RTCTokenModelCopyWithImpl<_$_RTCTokenModel>(this, _$identity);
}

abstract class _RTCTokenModel implements RTCTokenModel {
  factory _RTCTokenModel({required final String rtcToken}) = _$_RTCTokenModel;

  @override
  String get rtcToken;
  @override
  @JsonKey(ignore: true)
  _$$_RTCTokenModelCopyWith<_$_RTCTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}
