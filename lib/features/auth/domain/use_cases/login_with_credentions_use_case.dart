import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';

// ignore: one_member_abstracts
abstract class LoginWithCredentionsUseCase {
  Future<Result<LoginWithCredentionsUseCaseOutput, String>> call(
    LoginWithCredentionsUseCaseInput input,
  );
}

class LoginWithCredentionsUseCaseInput extends Equatable {
  const LoginWithCredentionsUseCaseInput({
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

class LoginWithCredentionsUseCaseOutput extends Equatable {
  const LoginWithCredentionsUseCaseOutput({
    required this.username,
  });

  final String username;

  @override
  List<Object> get props => [
        username,
      ];
}
