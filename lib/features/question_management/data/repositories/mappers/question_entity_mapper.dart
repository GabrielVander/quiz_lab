import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

class QuestionEntityMapper {
  Result<Question, QuestionMapperFailure> fromHiveModel(
    HiveQuestionModel hiveModel,
  ) {
    try {
      return Result.ok(_parseHiveModel(hiveModel));
    } on _FailureException catch (e) {
      return Result.err(e.failure);
    }
  }

  Question _parseHiveModel(HiveQuestionModel model) {
    return Question(
      id: _parseIdFromHiveModel(model),
      shortDescription: _parseShortDescriptionFromHiveModel(model),
      description: _parseDescriptionFromHiveModel(model),
      difficulty: _parseDifficultyFromHiveModel(model),
      categories: _parseCategoriesFromHiveModel(model),
      answerOptions: _parseOptionsFromHiveModel(model),
    );
  }

  String _parseIdFromHiveModel(HiveQuestionModel model) {
    if (model.id == null) {
      throw _FailureException(failure: QuestionMapperFailure.missingId());
    }

    return model.id!;
  }

  String _parseShortDescriptionFromHiveModel(HiveQuestionModel model) {
    if (model.shortDescription == null) {
      throw _FailureException(
        failure: QuestionMapperFailure.missingShortDescription(),
      );
    }

    return model.shortDescription!;
  }

  String _parseDescriptionFromHiveModel(HiveQuestionModel model) {
    if (model.description == null) {
      throw _FailureException(
        failure: QuestionMapperFailure.missingDescription(),
      );
    }

    return model.description!;
  }

  QuestionDifficulty _parseDifficultyFromHiveModel(HiveQuestionModel model) {
    if (model.difficulty == null) {
      throw _FailureException(
        failure: QuestionMapperFailure.missingDifficulty(),
      );
    }

    return _parseDifficultyFromString(model.difficulty!);
  }

  List<QuestionCategory> _parseCategoriesFromHiveModel(
    HiveQuestionModel model,
  ) {
    if (model.categories == null) {
      throw _FailureException(
        failure: QuestionMapperFailure.missingCategories(),
      );
    }

    return model.categories!.map((c) => QuestionCategory(value: c)).toList();
  }

  List<AnswerOption> _parseOptionsFromHiveModel(HiveQuestionModel model) {
    if (model.options == null) {
      throw _FailureException(
        failure: QuestionMapperFailure.missingCategories(),
      );
    }

    return model.options!
        .map(
          (o) => AnswerOption(
            description: o['description'] as String? ?? '',
            isCorrect: o['isCorrect'] as bool? ?? false,
          ),
        )
        .toList();
  }

  QuestionDifficulty _parseDifficultyFromString(String s) {
    const possibleDifficulties = <String, QuestionDifficulty>{
      'easy': QuestionDifficulty.easy,
      'medium': QuestionDifficulty.medium,
      'hard': QuestionDifficulty.hard,
      'unknown': QuestionDifficulty.unknown,
    };

    if (!possibleDifficulties.containsKey(s)) {
      throw _FailureException(
        failure: QuestionMapperFailure.unableToParseDifficulty(
          receivedValue: s,
          possibleValues: possibleDifficulties.keys.toList(),
        ),
      );
    }

    return possibleDifficulties[s]!;
  }
}

abstract class QuestionMapperFailure extends Equatable {
  const QuestionMapperFailure._({required this.message});

  factory QuestionMapperFailure.unableToParseDifficulty({
    required String receivedValue,
    required List<String> possibleValues,
  }) =>
      _UnableToParseDifficulty._(
        value: receivedValue,
        expectedOneOf: possibleValues,
      );

  factory QuestionMapperFailure.missingId() => _MissingId._();

  factory QuestionMapperFailure.missingShortDescription() =>
      _MissingShortDesc._();

  factory QuestionMapperFailure.missingDescription() => _MissingDescription._();

  factory QuestionMapperFailure.missingDifficulty() => _MissingDifficulty._();

  factory QuestionMapperFailure.missingCategories() => _MissingCategories._();

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _UnableToParseDifficulty extends QuestionMapperFailure {
  const _UnableToParseDifficulty._({
    required this.value,
    required this.expectedOneOf,
  }) : super._(
          message: 'Unable to parse difficulty. Expected one of $expectedOneOf '
              'but got $value instead',
        );

  final String value;
  final List<String> expectedOneOf;
}

abstract class _MissingAttribute extends QuestionMapperFailure {
  _MissingAttribute._({required this.attributeName})
      : super._(message: _buildMessage(attributeName));

  static String _buildMessage(String attributeName) {
    return 'Unable to map from hive model. No value found for required '
        'field $attributeName';
  }

  final String attributeName;

  @override
  List<Object> get props => super.props..addAll([attributeName]);
}

class _MissingId extends _MissingAttribute {
  _MissingId._() : super._(attributeName: 'id');
}

class _MissingShortDesc extends _MissingAttribute {
  _MissingShortDesc._() : super._(attributeName: 'shortDescription');
}

class _MissingDescription extends _MissingAttribute {
  _MissingDescription._() : super._(attributeName: 'description');
}

class _MissingDifficulty extends _MissingAttribute {
  _MissingDifficulty._() : super._(attributeName: 'difficulty');
}

class _MissingCategories extends _MissingAttribute {
  _MissingCategories._() : super._(attributeName: 'categories');
}

class _FailureException implements Exception {
  const _FailureException({
    required this.failure,
  });

  final QuestionMapperFailure failure;
}
