import 'package:fav_qs_api/src/models/request/user_credentials_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class SignInRequestRM {
  @JsonKey(name: 'user')
  final UserCredentialsRM credentials;

  const SignInRequestRM({required this.credentials});

  Map<String, dynamic> toJson() => _$SignInRequestRMToJson(this);
}
