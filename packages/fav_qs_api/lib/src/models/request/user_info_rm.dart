import 'package:json_annotation/json_annotation.dart';

part 'user_info_rm.g.dart';

@JsonSerializable(createFactory: false)
class UserInfoRM {
  @JsonKey(name: 'login')
  final String username;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String? password;

  const UserInfoRM({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$UserInfoRMToJson(this);
}
