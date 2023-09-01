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
    final environmentType = getOptionalEnvironmentVariable(EnvironmentVariable.environment);

    if (environmentType == null) {
      return EnvironmentType.development;
    }

    if (environmentType.toLowerCase() == 'prod' || environmentType.toLowerCase() == 'production') {
      return EnvironmentType.production;
    }

    return EnvironmentType.development;
  }

  static String? getOptionalEnvironmentVariable(EnvironmentVariable variable) => variable.getOptionalValue;
}

enum EnvironmentVariable {
  appwriteEndpoint,
  appwriteProjectId,
  environment,
  appwriteDatabaseId,
  appwriteQuestionCollectionId,
  appwriteProfileCollectionId,
  isBeta;

  String get getRequiredValue {
    final maybeValue = getOptionalValue;

    return maybeValue ?? (throw Exception('Required environment variable $name is not set'));
  }

  String? get getOptionalValue {
    switch (this) {
      case EnvironmentVariable.appwriteEndpoint:
        const key = 'APPWRITE_ENDPOINT';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.appwriteProjectId:
        const key = 'APPWRITE_PROJECT_ID';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.environment:
        const key = 'ENVIRONMENT';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.appwriteDatabaseId:
        const key = 'APPWRITE_DATABASE_ID';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.appwriteQuestionCollectionId:
        const key = 'APPWRITE_QUESTION_COLLECTION_ID';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.appwriteProfileCollectionId:
        const key = 'APPWRITE_PROFILE_COLLECTION_ID';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;

      case EnvironmentVariable.isBeta:
        const key = 'IS_BETA';

        return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;
    }
  }
}

enum EnvironmentType {
  development,
  production,
}
