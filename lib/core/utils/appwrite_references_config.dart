class AppwriteReferencesConfig {
  const AppwriteReferencesConfig({
    required this.databaseId,
    required this.questionCollectionId,
    required this.profileCollectionId,
  });

  final String databaseId;
  final String questionCollectionId;
  final String profileCollectionId;

  @override
  String toString() {
    return 'AppwriteDataSourceConfiguration{'
        'databaseId: $databaseId, '
        'questionCollectionId: $questionCollectionId'
        'profileCollectionId: $profileCollectionId'
        '}';
  }
}
