import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_preferences_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_user_dto.dart';

void main() {
  group('fromAppwriteModel', () {
    for (final testCase in [
      (
        User.fromMap(<String, dynamic>{
          'status': false,
          'emailVerification': false,
          'phoneVerification': false,
          'prefs': <String, dynamic>{},
          'labels': <String>[],
        }),
        const AppwriteUserDto(
          $id: '',
          $createdAt: '',
          $updatedAt: '',
          name: '',
          registration: '',
          status: false,
          passwordUpdate: '',
          email: '',
          phone: '',
          emailVerification: false,
          phoneVerification: false,
          prefs: AppwritePreferencesDto(data: <String, dynamic>{}),
        )
      ),
      (
        User.fromMap(<String, dynamic>{
          'status': true,
          'emailVerification': true,
          'phoneVerification': true,
          'prefs': <String, dynamic>{'we': 'are', 'the': 'champions', 'my': 'friend', 'Yx3Y': 573},
          'labels': <String>[],
        }),
        const AppwriteUserDto(
          $id: '',
          $createdAt: '',
          $updatedAt: '',
          name: '',
          registration: '',
          status: true,
          passwordUpdate: '',
          email: '',
          phone: '',
          emailVerification: true,
          phoneVerification: true,
          prefs: AppwritePreferencesDto(
            data: <String, dynamic>{'we': 'are', 'the': 'champions', 'my': 'friend', 'Yx3Y': 573},
          ),
        )
      ),
      (
        User.fromMap(<String, dynamic>{
          r'$id': 'T14WkXV',
          r'$createdAt': 'egSOFEe',
          r'$updatedAt': 'ZgNwe4X',
          'name': 'v2h0',
          'registration': 'grI',
          'passwordUpdate': 'mM4f4Q',
          'email': 'Pb7',
          'phone': 'uzpUT',
          'labels': <String>[],
          'status': false,
          'emailVerification': false,
          'phoneVerification': false,
          'prefs': <String, dynamic>{},
        }),
        const AppwriteUserDto(
          $id: 'T14WkXV',
          $createdAt: 'egSOFEe',
          $updatedAt: 'ZgNwe4X',
          name: 'v2h0',
          registration: 'grI',
          status: false,
          passwordUpdate: 'mM4f4Q',
          email: 'Pb7',
          phone: 'uzpUT',
          emailVerification: false,
          phoneVerification: false,
          prefs: AppwritePreferencesDto(data: <String, dynamic>{}),
        )
      ),
    ]) {
      final appwriteUser = testCase.$1;
      final expected = testCase.$2;

      test('$appwriteUser -> $expected', () {
        final result = AppwriteUserDto.fromAppwriteModel(appwriteUser);

        expect(result, expected);
      });
    }
  });
}
