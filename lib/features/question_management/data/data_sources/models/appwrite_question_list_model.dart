import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';

class AppwriteQuestionListModel extends Equatable {
  const AppwriteQuestionListModel({
    required this.total,
    required this.questions,
  });

  factory AppwriteQuestionListModel.fromAppwriteDocumentList(DocumentList documentList) => AppwriteQuestionListModel(
        total: documentList.total,
        questions: documentList.documents.map(AppwriteQuestionModel.fromDocument).toList(),
      );

  final int total;
  final List<AppwriteQuestionModel> questions;

  @override
  List<Object> get props => [total, questions];

  @override
  String toString() {
    return 'AppwriteQuestionListModel{total: $total, questions: $questions}';
  }
}
