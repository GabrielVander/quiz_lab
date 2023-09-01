import 'package:equatable/equatable.dart';

class QuestionOwner extends Equatable {
  const QuestionOwner({
    required this.displayName,
  });

  final String displayName;

  @override
  List<Object> get props => [displayName];
}
