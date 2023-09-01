import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';

class AppwriteRealtimeQuestionMessageModel extends Equatable {
  const AppwriteRealtimeQuestionMessageModel({
    required this.events,
    required this.channels,
    required this.timestamp,
    required this.payload,
  });

  factory AppwriteRealtimeQuestionMessageModel.fromRealtimeMessage(RealtimeMessage message) =>
      AppwriteRealtimeQuestionMessageModel(
        events: message.events,
        channels: message.channels,
        timestamp: message.timestamp,
        payload: AppwriteQuestionModel.fromMap(message.payload),
      );

  final List<String> events;
  final List<String> channels;
  final String timestamp;
  final AppwriteQuestionModel payload;

  @override
  List<Object> get props => [
        events,
        channels,
        timestamp,
        payload,
      ];
}
