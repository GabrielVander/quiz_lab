import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_preferences_dto.dart';

void main() {
  group('fromAppwriteModel', () {
    for (final testCase in [
      (<String, dynamic>{}, const AppwritePreferencesDto(data: <String, dynamic>{})),
      (
        <String, dynamic>{
          'q5GkCY2D': '1nBJ39d',
        },
        const AppwritePreferencesDto(
          data: <String, dynamic>{
            'q5GkCY2D': '1nBJ39d',
          },
        )
      ),
      (
        <String, dynamic>{
          '8jE4': 536,
          'NLZCPJ': 'GR4lCi',
          'QHRU': 8.36,
        },
        const AppwritePreferencesDto(
          data: <String, dynamic>{
            '8jE4': 536,
            'NLZCPJ': 'GR4lCi',
            'QHRU': 8.36,
          },
        )
      ),
    ]) {
      test('${testCase.$1} -> ${testCase.$2}', () {
        final appwriteModel = Preferences.fromMap(testCase.$1);

        final model = AppwritePreferencesDto.fromAppwriteModel(appwriteModel);

        expect(model, testCase.$2);
      });
    }
  });
}
