import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_realtime_message_model.dart';

class AppwriteDataSource {
  AppwriteDataSource({
    required Databases appwriteDatabasesService,
    required AppwriteReferencesConfig configuration,
    required Realtime appwriteRealtimeService,
  })  : _appwriteDatabasesService = appwriteDatabasesService,
        _appwriteRealtimeService = appwriteRealtimeService,
        _configuration = configuration;

  final _logger = QuizLabLoggerFactory.createLogger<AppwriteDataSource>();

  final Databases _appwriteDatabasesService;
  final Realtime _appwriteRealtimeService;
  final AppwriteReferencesConfig _configuration;

  Stream<AppwriteRealtimeQuestionMessageModel> watchForQuestionCollectionUpdate() {
    _logger.debug('Watching for question collection updates...');

    final s = _appwriteRealtimeService.subscribe([
      'databases'
          '.${_configuration.databaseId}'
          '.collections'
          '.${_configuration.questionsCollectionId}'
          '.documents'
    ]);

    return s.stream.map(AppwriteRealtimeQuestionMessageModel.fromRealtimeMessage);
  }

  Future<AppwriteQuestionListModel> getAllQuestions() async {
    _logger.debug('Retrieving all questions...');

    final documentList = await _appwriteDatabasesService.listDocuments(
      databaseId: _configuration.databaseId,
      collectionId: _configuration.questionsCollectionId,
    );

    _logger.debug('Retrieved ${documentList.total} questions');

    return AppwriteQuestionListModel(
      total: documentList.total,
      questions: documentList.documents.map(AppwriteQuestionModel.fromDocument).toList(),
    );
  }
}

class AppwriteReferencesConfig {
  const AppwriteReferencesConfig({
    required this.databaseId,
    required this.questionsCollectionId,
  });

  final String databaseId;
  final String questionsCollectionId;

  @override
  String toString() {
    return 'AppwriteDataSourceConfiguration{'
        'databaseId: $databaseId, '
        'questionsCollectionId: $questionsCollectionId'
        '}';
  }
}

abstract class AppwriteDataSourceFailure extends Equatable {
  const AppwriteDataSourceFailure._();

  factory AppwriteDataSourceFailure.unexpected(Exception exception) => AppwriteDataSourceUnexpectedFailure._(exception);
}

class AppwriteDataSourceUnexpectedFailure extends AppwriteDataSourceFailure {
  const AppwriteDataSourceUnexpectedFailure._(this.exception) : super._();

  final Exception exception;

  @override
  List<Object?> get props => [
        exception,
      ];
}
