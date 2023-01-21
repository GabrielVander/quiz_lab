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
}

enum EnvironmentVariable {
  appwriteEndpoint,
  appwriteProjectId,
  environment,
}

enum EnvironmentType {
  development,
  production,
}
