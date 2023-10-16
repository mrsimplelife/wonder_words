import 'package:fav_qs_api/src/models/request/user_email_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_reset_email_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class PasswordResetEmailRequestRM {
  @JsonKey(name: 'user')
  final UserEmailRM user;

  const PasswordResetEmailRequestRM({required this.user});

  Map<String, dynamic> toJson() => _$PasswordResetEmailRequestRMToJson(this);
}
