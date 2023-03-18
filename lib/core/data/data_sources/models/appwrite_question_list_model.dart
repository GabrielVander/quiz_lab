import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';

class AppwriteQuestionListModel extends Equatable {
  const AppwriteQuestionListModel({
    required this.total,
    required this.questions,
  });

  final int total;
  final List<AppwriteQuestionModel> questions;

  @override
  List<Object> get props => [
        total,
        questions,
      ];

  @override
  String toString() {
    return 'AppwriteQuestionListModel{total: $total, questions: $questions}';
  }
}
