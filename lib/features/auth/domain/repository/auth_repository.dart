import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';

// ignore: one_member_abstracts
abstract class AuthRepository {
  Future<Result<Unit, AuthRepositoryError>> loginWithEmailCredentials(
    EmailCredentials credentials,
  );
}

abstract class AuthRepositoryError {
  const AuthRepositoryError._();

  factory AuthRepositoryError.unexpected({required String message}) =>
      AuthRepositoryUnexpectedError._(message: message);
}

class EmailCredentials extends Equatable {
  const EmailCredentials({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

@immutable
class AuthRepositoryUnexpectedError extends AuthRepositoryError {
  const AuthRepositoryUnexpectedError._({required this.message}) : super._();

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthRepositoryUnexpectedError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
