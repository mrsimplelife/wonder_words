import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class SignUpRequestRM {
  @JsonKey(name: 'user')
  final UserInfoRM user;

  const SignUpRequestRM({required this.user});

  Map<String, dynamic> toJson() => _$SignUpRequestRMToJson(this);
}
