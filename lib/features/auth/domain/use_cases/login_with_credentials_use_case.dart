import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';

// ignore: one_member_abstracts
abstract class LoginWithCredentialsUseCase {
  Future<Result<Unit, String>> call(
    LoginWithCredentialsUseCaseInput input,
  );
}

class LoginWithCredentialsUseCaseInput extends Equatable {
  const LoginWithCredentialsUseCaseInput({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [
        email,
        password,
      ];
}
