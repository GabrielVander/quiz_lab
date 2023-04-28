import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

class Environment {
  static final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<Environment>();

  static String getRequiredEnvironmentVariable(EnvironmentVariable variable) {
    final value = getOptionalEnvironmentVariable(variable);
    if (value == null) {
      throw Exception(
        'Required environment variable $variable is not set',
      );
    }

    return value;
  }

  static EnvironmentType getEnvironmentType() {
    final environmentType =
    getOptionalEnvironmentVariable(EnvironmentVariable.environment);

    if (environmentType == null) {
      return EnvironmentType.development;
    }

    if (environmentType.toLowerCase() == 'prod' ||
        environmentType.toLowerCase() == 'production') {
      return EnvironmentType.production;
    }

    return EnvironmentType.development;
  }

  static String? getOptionalEnvironmentVariable(EnvironmentVariable variable) {
    switch (variable) {
      case EnvironmentVariable.appwriteEndpoint:
        return _appwriteEndpoint();
      case EnvironmentVariable.appwriteProjectId:
        return _appwriteProjectId();
      case EnvironmentVariable.environment:
        return _environment();
      case EnvironmentVariable.appwriteDatabaseId:
        return _appwriteDatabaseId();
      case EnvironmentVariable.appwriteQuestionCollectionId:
        return _appwriteQuestionCollectionId();
      case EnvironmentVariable.isBeta:
        return _isBeta();
    }
  }

  static String? _appwriteEndpoint() =>
      const bool.hasEnvironment('APPWRITE_ENDPOINT')
          ? const String.fromEnvironment('APPWRITE_ENDPOINT')
          : null;

  static String? _appwriteProjectId() =>
      const bool.hasEnvironment('APPWRITE_PROJECT_ID')
          ? const String.fromEnvironment('APPWRITE_PROJECT_ID')
          : null;

  static String? _environment() => const bool.hasEnvironment('ENVIRONMENT')
      ? const String.fromEnvironment('ENVIRONMENT')
      : null;

  static String? _appwriteDatabaseId() =>
      const bool.hasEnvironment('APPWRITE_DATABASE_ID')
          ? const String.fromEnvironment('APPWRITE_DATABASE_ID')
          : null;

  static String? _appwriteQuestionCollectionId() =>
      const bool.hasEnvironment('APPWRITE_QUESTION_COLLECTION_ID')
          ? const String.fromEnvironment('APPWRITE_QUESTION_COLLECTION_ID')
          : null;

  static String? _isBeta() {
    const key = 'IS_BETA';

    _logger.debug('Checking for environment variable $key');

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }
}

enum EnvironmentVariable {
  appwriteEndpoint,
  appwriteProjectId,
  environment,
  appwriteDatabaseId,
  appwriteQuestionCollectionId,
  isBeta,
}

enum EnvironmentType {
  development,
  production,
}
