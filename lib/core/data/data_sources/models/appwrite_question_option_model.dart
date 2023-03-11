import 'package:equatable/equatable.dart';

class AppwriteQuestionOptionModel extends Equatable {
  const AppwriteQuestionOptionModel({
    required this.description,
    required this.isCorrect,
  });

  factory AppwriteQuestionOptionModel.fromMap(Map<String, dynamic> map) {
    return AppwriteQuestionOptionModel(
      description: map['description'] as String,
      isCorrect: map['isCorrect'] as bool,
    );
  }

  final String description;
  final bool isCorrect;

  @override
  List<Object> get props => [
        description,
        isCorrect,
      ];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isCorrect': isCorrect,
    };
  }
}
