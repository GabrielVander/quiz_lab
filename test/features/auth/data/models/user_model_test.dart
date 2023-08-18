import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/data/models/preferences_model.dart';
import 'package:quiz_lab/core/data/models/user_model.dart';

void main() {
  group('fromAppwriteModel', () {
    for (final testCase in [
      (
        <String, dynamic>{
          'status': false,
          'emailVerification': false,
          'phoneVerification': false,
          'prefs': <String, dynamic>{},
        },
        const UserModel(
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
          prefs: PreferencesModel(data: <String, dynamic>{}),
        )
      ),
      (
        <String, dynamic>{
          'status': true,
          'emailVerification': true,
          'phoneVerification': true,
          'prefs': <String, dynamic>{'we': 'are', 'the': 'champions', 'my': 'friend', 'Yx3Y': 573},
        },
        const UserModel(
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
          prefs: PreferencesModel(
            data: <String, dynamic>{'we': 'are', 'the': 'champions', 'my': 'friend', 'Yx3Y': 573},
          ),
        )
      ),
      (
        <String, dynamic>{
          r'$id': 'T14WkXV',
          r'$createdAt': 'egSOFEe',
          r'$updatedAt': 'ZgNwe4X',
          'name': 'v2h0',
          'registration': 'grI',
          'passwordUpdate': 'mM4f4Q',
          'email': 'Pb7',
          'phone': 'uzpUT',
          'status': false,
          'emailVerification': false,
          'phoneVerification': false,
          'prefs': <String, dynamic>{},
        },
        const UserModel(
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
          prefs: PreferencesModel(data: <String, dynamic>{}),
        )
      ),
    ]) {
      test('${testCase.$1} -> ${testCase.$2}', () {
        final appwriteModel = User.fromMap(testCase.$1);

        final result = UserModel.fromAppwriteModel(appwriteModel);

        expect(result, testCase.$2);
      });
    }
  });
}
