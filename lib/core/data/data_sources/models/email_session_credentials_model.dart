import 'package:equatable/equatable.dart';

class EmailSessionCredentialsModel extends Equatable {
  const EmailSessionCredentialsModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
