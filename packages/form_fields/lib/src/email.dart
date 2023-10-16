import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class Email extends FormzInput<String, EmailValidationError>
    with EquatableMixin {
  static final _emailRegex = RegExp(
    '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
    '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
    '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$',
  );

  final bool isAlreadyRegistered;

  const Email.unvalidated([String value = ''])
      : isAlreadyRegistered = false,
        super.pure(value);

  const Email.validated(String value, {this.isAlreadyRegistered = false})
      : super.dirty(value);

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    if (isAlreadyRegistered) {
      return EmailValidationError.alreadyRegistered;
    }
    if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }

  @override
  List<Object?> get props => [value, pure, isAlreadyRegistered];
}

enum EmailValidationError { empty, invalid, alreadyRegistered }
