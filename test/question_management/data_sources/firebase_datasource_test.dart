import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/question_model.dart';

void main() {
  late FirebaseFirestore firebaseFirestore;
  late FirebaseDataSource dataSource;

  setUp(() {
    firebaseFirestore = _FirebaseFirestoreMock();
    dataSource = FirebaseDataSource(firestore: firebaseFirestore);
  });

  tearDown(mocktail.resetMocktailState);

  group('watchPublicQuestions', () {
    late CollectionReference<Map<String, dynamic>> dummyCollectionReference;

    setUp(() {
      dummyCollectionReference = _CollectionReferenceMock();
    });

    test('should call Firestore correctly', () {
      const dummySnapshotStream =
          Stream<QuerySnapshot<Map<String, dynamic>>>.empty();

      mocktail
          .when(dummyCollectionReference.snapshots)
          .thenAnswer((_) => dummySnapshotStream);

      mocktail
          .when(() => firebaseFirestore.collection(mocktail.any()))
          .thenReturn(dummyCollectionReference);

      dataSource.watchPublicQuestions();

      mocktail.verifyInOrder([
        () => firebaseFirestore.collection('questions'),
        dummyCollectionReference.snapshots,
      ]);
    });

    group('should map snapshots correctly', () {
      for (final testCase in [
        const _MappingTestCase(snapshots: [], expectedOutput: []),
        const _MappingTestCase(
          snapshots: [_DummySnapshotData(documents: [])],
          expectedOutput: [],
        ),
        const _MappingTestCase(
          snapshots: [
            _DummySnapshotData(
              documents: [
                _DocumentDummyData(id: '*3G2g', content: <String, dynamic>{})
              ],
            )
          ],
          expectedOutput: [
            [
              QuestionModel(
                id: '*3G2g',
                shortDescription: '',
                description: '',
                difficulty: '',
                categories: [],
              )
            ]
          ],
        ),
        const _MappingTestCase(
          snapshots: [
            _DummySnapshotData(
              documents: [
                _DocumentDummyData(id: '*3G2g', content: <String, dynamic>{}),
                _DocumentDummyData(id: '@2sn', content: <String, dynamic>{})
              ],
            ),
          ],
          expectedOutput: [
            [
              QuestionModel(
                id: '*3G2g',
                shortDescription: '',
                description: '',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: '@2sn',
                shortDescription: '',
                description: '',
                difficulty: '',
                categories: [],
              )
            ]
          ],
        ),
        const _MappingTestCase(
          snapshots: [
            _DummySnapshotData(
              documents: [
                _DocumentDummyData(
                  id: '*3G2g',
                  content: <String, dynamic>{
                    'shortDescription': 'officer',
                  },
                ),
                _DocumentDummyData(
                  id: '67#',
                  content: <String, dynamic>{
                    'shortDescription': 'toward',
                    'description': 'post'
                  },
                ),
                _DocumentDummyData(
                  id: 'ynh#',
                  content: <String, dynamic>{
                    'shortDescription': 'nor',
                    'description': 'voice',
                    'difficulty': 'fast',
                  },
                ),
                _DocumentDummyData(
                  id: 'Q&1iwed@',
                  content: <String, dynamic>{
                    'shortDescription': 'might',
                    'description': 'fan',
                    'difficulty': 'hear',
                    'categories': [
                      'kYK',
                      '649',
                      '1WMV8L',
                    ],
                  },
                ),
              ],
            ),
          ],
          expectedOutput: [
            [
              QuestionModel(
                id: '*3G2g',
                shortDescription: 'officer',
                description: '',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: '67#',
                shortDescription: 'toward',
                description: 'post',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: 'ynh#',
                shortDescription: 'nor',
                description: 'voice',
                difficulty: 'fast',
                categories: [],
              ),
              QuestionModel(
                id: 'Q&1iwed@',
                shortDescription: 'might',
                description: 'fan',
                difficulty: 'hear',
                categories: [
                  'kYK',
                  '649',
                  '1WMV8L',
                ],
              ),
            ]
          ],
        ),
        const _MappingTestCase(
          snapshots: [
            _DummySnapshotData(
              documents: [
                _DocumentDummyData(
                  id: '*3G2g',
                  content: <String, dynamic>{
                    'shortDescription': 'officer',
                  },
                ),
                _DocumentDummyData(
                  id: '67#',
                  content: <String, dynamic>{
                    'shortDescription': 'toward',
                    'description': 'post'
                  },
                ),
                _DocumentDummyData(
                  id: 'ynh#',
                  content: <String, dynamic>{
                    'shortDescription': 'nor',
                    'description': 'voice',
                    'difficulty': 'fast',
                  },
                ),
                _DocumentDummyData(
                  id: 'Q&1iwed@',
                  content: <String, dynamic>{
                    'shortDescription': 'might',
                    'description': 'fan',
                    'difficulty': 'hear',
                    'categories': [
                      'kYK',
                      '649',
                      '1WMV8L',
                    ],
                  },
                ),
              ],
            ),
            _DummySnapshotData(
              documents: [
                _DocumentDummyData(
                  id: 'zS6',
                  content: <String, dynamic>{
                    'shortDescription': 'religion',
                  },
                ),
                _DocumentDummyData(
                  id: 'LsH',
                  content: <String, dynamic>{
                    'shortDescription': 'language',
                    'description': 'death'
                  },
                ),
                _DocumentDummyData(
                  id: '^35srT@',
                  content: <String, dynamic>{
                    'shortDescription': 'quantity',
                    'description': 'temple',
                    'difficulty': 'limit',
                  },
                ),
                _DocumentDummyData(
                  id: 'xS8',
                  content: <String, dynamic>{
                    'shortDescription': 'wire',
                    'description': 'mystery',
                    'difficulty': 'weigh',
                    'categories': [
                      'MUh',
                      'p%2',
                      '8kB',
                    ],
                  },
                ),
              ],
            ),
          ],
          expectedOutput: [
            [
              QuestionModel(
                id: '*3G2g',
                shortDescription: 'officer',
                description: '',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: '67#',
                shortDescription: 'toward',
                description: 'post',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: 'ynh#',
                shortDescription: 'nor',
                description: 'voice',
                difficulty: 'fast',
                categories: [],
              ),
              QuestionModel(
                id: 'Q&1iwed@',
                shortDescription: 'might',
                description: 'fan',
                difficulty: 'hear',
                categories: [
                  'kYK',
                  '649',
                  '1WMV8L',
                ],
              ),
            ],
            [
              QuestionModel(
                id: 'zS6',
                shortDescription: 'religion',
                description: '',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: 'LsH',
                shortDescription: 'language',
                description: 'death',
                difficulty: '',
                categories: [],
              ),
              QuestionModel(
                id: '^35srT@',
                shortDescription: 'quantity',
                description: 'temple',
                difficulty: 'limit',
                categories: [],
              ),
              QuestionModel(
                id: 'xS8',
                shortDescription: 'wire',
                description: 'mystery',
                difficulty: 'weigh',
                categories: [
                  'MUh',
                  'p%2',
                  '8kB',
                ],
              ),
            ]
          ],
        ),
      ]) {
        test(testCase.toString(), () async {
          final snapshots = _buildMockSnapshots(testCase.snapshots);

          final dummySnapshotStream =
              Stream<QuerySnapshot<Map<String, dynamic>>>.fromIterable(
            snapshots,
          );

          mocktail
              .when(dummyCollectionReference.snapshots)
              .thenAnswer((_) => dummySnapshotStream);

          mocktail
              .when(() => firebaseFirestore.collection(mocktail.any()))
              .thenReturn(dummyCollectionReference);

          final result = dataSource.watchPublicQuestions();

          await expectLater(result, emitsInOrder(testCase.expectedOutput));
        });
      }
    });
  });

  group('deletePublicQuestionById', () {
    late CollectionReference<Map<String, dynamic>> dummyCollectionReference;

    setUp(() {
      dummyCollectionReference = _CollectionReferenceMock();
    });

    group('should call Firestore correctly', () {
      for (final id in ['id', 'BRu81Y']) {
        test(id, () async {
          final dummyDocReference = _DocumentReferenceMock();

          mocktail.when(dummyDocReference.delete).thenAnswer((_) async {});

          mocktail
              .when(() => dummyCollectionReference.doc(mocktail.any()))
              .thenReturn(dummyDocReference);

          mocktail
              .when(() => firebaseFirestore.collection(mocktail.any()))
              .thenReturn(dummyCollectionReference);

          await dataSource.deletePublicQuestionById(id);

          mocktail.verifyInOrder([
            () => firebaseFirestore.collection('questions'),
            () => dummyCollectionReference.doc(id),
            dummyDocReference.delete
          ]);
        });
      }
    });
  });

  group('createPublicQuestion', () {
    late CollectionReference<Map<String, dynamic>> dummyCollectionReference;

    setUp(() {
      dummyCollectionReference = _CollectionReferenceMock();
    });

    test('should call Firestore correctly', () async {
      final modelMock = _QuestionModelMock();
      final dummyMap = _FakeMap();

      mocktail.when(modelMock.toMap).thenReturn(dummyMap);

      mocktail
          .when(() => dummyCollectionReference.add(mocktail.any()))
          .thenAnswer((_) async => _DocumentReferenceMock());

      mocktail
          .when(() => firebaseFirestore.collection(mocktail.any()))
          .thenReturn(dummyCollectionReference);

      await dataSource.createPublicQuestion(modelMock);

      mocktail.verifyInOrder([
        () => firebaseFirestore.collection('questions'),
        () => dummyCollectionReference.add(dummyMap),
      ]);
    });
  });

  group('updateQuestion', () {
    late CollectionReference<Map<String, dynamic>> dummyCollectionReference;

    setUp(() {
      dummyCollectionReference = _CollectionReferenceMock();
    });

    test('should call Firestore correctly', () async {
      final modelMock = _QuestionModelMock();
      const dummyId = 'rnop1suS';
      final dummyMap = _FakeMap();
      final dummyDocumentReference = _DocumentReferenceMock();

      mocktail.when(modelMock.toMap).thenReturn(dummyMap);
      mocktail.when(() => modelMock.id).thenReturn(dummyId);

      mocktail
          .when(() => dummyDocumentReference.update(mocktail.any()))
          .thenAnswer((_) async {});

      mocktail
          .when(() => dummyCollectionReference.doc(mocktail.any()))
          .thenReturn(dummyDocumentReference);

      mocktail
          .when(() => firebaseFirestore.collection(mocktail.any()))
          .thenReturn(dummyCollectionReference);

      await dataSource.updateQuestion(modelMock);

      mocktail.verifyInOrder([
        () => firebaseFirestore.collection('questions'),
        () => modelMock.id,
        () => dummyCollectionReference.doc(dummyId),
        modelMock.toMap,
        () => dummyDocumentReference.update(dummyMap),
      ]);
    });
  });
}

List<QuerySnapshot<Map<String, dynamic>>> _buildMockSnapshots(
  List<_DummySnapshotData> snapshotsData,
) {
  return snapshotsData
      .map<QuerySnapshot<Map<String, dynamic>>>(_snapshotDataAsMock)
      .toList();
}

_QuerySnapshotMock _snapshotDataAsMock(_DummySnapshotData snapData) {
  final mockDocuments = _buildMockDocumentSnapshot(snapData.documents);

  final mock = _QuerySnapshotMock();
  mocktail.when(() => mock.docs).thenReturn(mockDocuments);

  return mock;
}

List<QueryDocumentSnapshot<Map<String, dynamic>>> _buildMockDocumentSnapshot(
  List<_DocumentDummyData> documentsData,
) {
  return documentsData
      .map<QueryDocumentSnapshot<Map<String, dynamic>>>(_documentDataAsMock)
      .toList();
}

_QueryDocumentSnapshotMock _documentDataAsMock(_DocumentDummyData docData) {
  final mock = _QueryDocumentSnapshotMock();

  mocktail.when(() => mock.id).thenReturn(docData.id);
  mocktail.when(mock.data).thenReturn(docData.content);

  return mock;
}

class _MappingTestCase {
  const _MappingTestCase({
    required this.snapshots,
    required this.expectedOutput,
  });

  final List<_DummySnapshotData> snapshots;
  final List<List<QuestionModel>> expectedOutput;

  @override
  String toString() {
    return '_MappingTestCase{'
        'snapshots: $snapshots, '
        'expectedOutput: $expectedOutput'
        '}';
  }
}

class _DummySnapshotData {
  const _DummySnapshotData({
    required this.documents,
  });

  final List<_DocumentDummyData> documents;
}

class _DocumentDummyData {
  const _DocumentDummyData({
    required this.id,
    required this.content,
  });

  final String id;
  final Map<String, dynamic> content;
}

class _FirebaseFirestoreMock extends mocktail.Mock
    implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class _CollectionReferenceMock extends mocktail.Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _QuerySnapshotMock extends mocktail.Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class _QueryDocumentSnapshotMock extends mocktail.Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class _DocumentReferenceMock extends mocktail.Mock
    implements DocumentReference<Map<String, dynamic>> {}

class _QuestionModelMock extends mocktail.Mock implements QuestionModel {}

class _FakeMap extends mocktail.Fake implements Map<String, dynamic> {}
