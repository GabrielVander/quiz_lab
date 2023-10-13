import 'package:equatable/equatable.dart';

class CreateAppwriteEmailSessionDto extends Equatable {
  const CreateAppwriteEmailSessionDto({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
