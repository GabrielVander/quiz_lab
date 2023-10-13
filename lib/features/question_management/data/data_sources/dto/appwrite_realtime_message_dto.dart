import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_dto.dart';

class AppwriteRealtimeQuestionMessageDto extends Equatable {
  const AppwriteRealtimeQuestionMessageDto({
    required this.events,
    required this.channels,
    required this.timestamp,
    required this.payload,
  });

  factory AppwriteRealtimeQuestionMessageDto.fromRealtimeMessage(RealtimeMessage message) =>
      AppwriteRealtimeQuestionMessageDto(
        events: message.events,
        channels: message.channels,
        timestamp: message.timestamp,
        payload: AppwriteQuestionDto.fromMap(message.payload),
      );

  final List<String> events;
  final List<String> channels;
  final String timestamp;
  final AppwriteQuestionDto payload;

  @override
  List<Object> get props => [
        events,
        channels,
        timestamp,
        payload,
      ];
}
