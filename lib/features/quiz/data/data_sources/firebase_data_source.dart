import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<QuestionModel>> watchPublicQuestions() {
    final collectionPath = PublicQuestions().getFirebasePath();

    return _firestore.collection(collectionPath).snapshots().map(
          (snapshot) => snapshot.docs
              .map((e) => QuestionModel.fromMap(e.id, e.data()))
              .toList(),
        );
  }

  Future<void> deletePublicQuestionById(String id) async {
    final collectionPath = PublicQuestions().getFirebasePath();

    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Future<void> createPublicQuestion(QuestionModel question) async {
    final collectionPath = PublicQuestions().getFirebasePath();

    await _firestore.collection(collectionPath).add(question.toMap());
  }

  Future<void> updateQuestion(QuestionModel question) async {
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
