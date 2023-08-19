import 'package:equatable/equatable.dart';

class CurrentUserSession extends Equatable {
  const CurrentUserSession({
    required this.provider,
  });

  final SessionProvider provider;

  @override
  String toString() => 'Session{provider: $provider}';

  @override
  List<Object> get props => [provider];
}

enum SessionProvider {
  email,
  anonymous,
  unknown,
}
