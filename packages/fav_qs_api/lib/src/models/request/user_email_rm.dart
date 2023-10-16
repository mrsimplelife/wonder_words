import 'package:json_annotation/json_annotation.dart';

part 'user_email_rm.g.dart';

@JsonSerializable(createFactory: false)
class UserEmailRM {
  @JsonKey(name: 'email')
  final String email;

  const UserEmailRM({required this.email});

  Map<String, dynamic> toJson() => _$UserEmailRMToJson(this);
}
