class Environment {
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

  static String? _appwriteEndpoint() {
    const key = 'APPWRITE_ENDPOINT';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }

  static String? _appwriteProjectId() {
    const key = 'APPWRITE_PROJECT_ID';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }

  static String? _environment() {
    const key = 'ENVIRONMENT';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }

  static String? _appwriteDatabaseId() {
    const key = 'APPWRITE_DATABASE_ID';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }

  static String? _appwriteQuestionCollectionId() {
    const key = 'APPWRITE_QUESTION_COLLECTION_ID';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : null;
  }

  static String? _isBeta() {
    const key = 'IS_BETA';

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
