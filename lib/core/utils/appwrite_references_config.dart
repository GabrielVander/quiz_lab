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
