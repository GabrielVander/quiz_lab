import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/question_model.dart';

class FirebaseDataSource {
  FirebaseDataSource({
    required FirebaseFirestore firestore,
  }) {
    _firestore = firestore;
  }

  late FirebaseFirestore _firestore;

  Stream<List<HiveQuestionModel>> watchPublicQuestions() {
    final collectionPath = PublicQuestions().getFirebasePath();

    return _firestore.collection(collectionPath).snapshots().map(
          (snapshot) => snapshot.docs
              .map((e) => HiveQuestionModel.fromMap(e.id, e.data()))
              .toList(),
        );
  }

  Future<void> deletePublicQuestionById(String id) async {
    final collectionPath = PublicQuestions().getFirebasePath();

    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Future<void> createPublicQuestion(HiveQuestionModel question) async {
    final collectionPath = PublicQuestions().getFirebasePath();

    await _firestore.collection(collectionPath).add(question.toMap());
  }

  Future<void> updateQuestion(HiveQuestionModel question) async {
    final collectionPath = PublicQuestions().getFirebasePath();

    await _firestore
        .collection(collectionPath)
        .doc(question.id)
        .update(question.toMap());
  }
}

mixin FirebaseCollection {
  String getFirebasePath();
}

class PublicQuestions with FirebaseCollection {
  @override
  String getFirebasePath() {
    return 'questions';
  }
}
