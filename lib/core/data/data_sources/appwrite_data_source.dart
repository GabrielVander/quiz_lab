import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_realtime_message_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/session_model.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';

class AppwriteDataSource {
  AppwriteDataSource({
    required Account appwriteAccountService,
    required Databases appwriteDatabasesService,
    required AppwriteDataSourceConfiguration configuration,
    required Realtime appwriteRealtimeService,
  })  : _appwriteAccountService = appwriteAccountService,
        _appwriteDatabasesService = appwriteDatabasesService,
        _appwriteRealtimeService = appwriteRealtimeService,
        _configuration = configuration;

  final _logger = QuizLabLoggerFactory.createLogger<AppwriteDataSource>();

  final Account _appwriteAccountService;
  final Databases _appwriteDatabasesService;
  final Realtime _appwriteRealtimeService;
  final AppwriteReferencesConfig _configuration;

  Future<Result<SessionModel, String>> createEmailSession(
    EmailSessionCredentialsModel credentialsModel,
  ) async {
    _logger.debug('Creating email session...');

    try {
      final session = await _appwriteAccountService.createEmailSession(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );

      _logger.debug('Email session created successfully');

      return Result.ok(
        SessionModel(
          userId: session.userId,
          sessionId: session.$id,
          sessionCreationDate: session.$createdAt,
          sessionExpirationDate: session.expire,
          sessionProviderInfo: ProviderInfo(
            uid: session.providerUid,
            name: session.provider,
            accessToken: session.providerAccessToken,
            accessTokenExpirationDate: session.providerAccessTokenExpiry,
            refreshToken: session.providerRefreshToken,
          ),
          ipUsedInSession: session.ip,
          operatingSystemInfo: OperatingSystemInfo(
            code: session.osCode,
            name: session.osName,
            version: session.osVersion,
          ),
          clientInfo: ClientInfo(
            type: session.clientType,
            code: session.clientCode,
            name: session.clientName,
            version: session.clientVersion,
            engineName: session.clientEngine,
            engineVersion: session.clientEngineVersion,
          ),
          deviceInfo: DeviceInfo(
            name: session.deviceName,
            brand: session.deviceBrand,
            model: session.deviceModel,
          ),
          countryCode: session.countryCode,
          countryName: session.countryName,
          isCurrentSession: session.current,
        ),
      );
    } on AppwriteException catch (e) {
      _logger.error(e.toString());

      return Result.err(e.toString());
    }
  }

  Future<Result<AppwriteQuestionCreationModel, AppwriteDataSourceFailure>>
      createQuestion(
    AppwriteQuestionCreationModel question,
  ) async {
    _logger.debug('Creating question document...');

    try {
      await _appwriteDatabasesService.createDocument(
        databaseId: _configuration.databaseId,
        collectionId: _configuration.questionsCollectionId,
        documentId: question.id,
        data: question.toMap(),
      );

      _logger.debug('Question document created successfully');
      return Result.ok(question);
    } on Exception catch (e) {
      _logger.error(e.toString());
      return Result.err(AppwriteDataSourceFailure.unexpected(e));
    }
  }

  Stream<AppwriteRealtimeQuestionMessageModel>
      watchForQuestionCollectionUpdate() {
    _logger.debug('Watching for question collection updates...');

    final s = _appwriteRealtimeService.subscribe([
      'databases'
          '.${_configuration.databaseId}'
          '.collections'
          '.${_configuration.questionsCollectionId}'
          '.documents'
    ]);

    return s.stream
        .map(AppwriteRealtimeQuestionMessageModel.fromRealtimeMessage);
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
      questions: documentList.documents
          .map(AppwriteQuestionModel.fromDocument)
          .toList(),
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

  factory AppwriteDataSourceFailure.unexpected(Exception exception) =>
      AppwriteDataSourceUnexpectedFailure._(exception);
}

class AppwriteDataSourceUnexpectedFailure extends AppwriteDataSourceFailure {
  const AppwriteDataSourceUnexpectedFailure._(this.exception) : super._();

  final Exception exception;

  @override
  List<Object?> get props => [
        exception,
      ];
}
