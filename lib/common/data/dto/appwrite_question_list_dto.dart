import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';

class AppwriteQuestionListDto extends Equatable {
  const AppwriteQuestionListDto({
    required this.total,
    required this.questions,
  });

  factory AppwriteQuestionListDto.fromAppwriteDocumentList(DocumentList documentList) => AppwriteQuestionListDto(
        total: documentList.total,
        questions: documentList.documents.map(AppwriteQuestionDto.fromDocument).toList(),
      );

  final int total;
  final List<AppwriteQuestionDto> questions;

  @override
  List<Object> get props => [total, questions];

  @override
  String toString() {
    return 'AppwriteQuestionListDto{total: $total, questions: $questions}';
  }
}
