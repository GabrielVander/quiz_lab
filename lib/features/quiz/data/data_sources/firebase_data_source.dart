import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<QuestionModel>> fetchPublicQuestions() {
    final collectionPath = PublicQuestions().getFirebasePath();

    return _firestore.collection(collectionPath).snapshots().map(
          (snapshot) => snapshot.docs
              .map((e) => QuestionModel.fromMap(e.id, e.data()))
              .toList(),
        );
  }
}

abstract class FirebaseCollection {
  String getFirebasePath();
}

class PublicQuestions implements FirebaseCollection {
  @override
  String getFirebasePath() {
    return 'questions';
  }
}
