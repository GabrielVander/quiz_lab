import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

void main() {
  group('EmailViewModel', () {
    group('copyWith', () {
      group(
        'should return a new instance of [EmailViewModel] with given values',
        () {
          for (final values in [
            [
              const EmailViewModel(value: ''),
              const EmailViewModel(value: 'vX3qp9d', showError: true)
            ],
            [
              const EmailViewModel(value: '*Uqi', showError: true),
              const EmailViewModel(value: 'QxE@2')
            ],
          ]) {
            test(values.toString(), () {
              final original = values[0];
              final copy = values[1];

              final result = original.copyWith(
                value: copy.value,
                showError: copy.showError,
              );

              expect(result, copy);
            });
          }
        },
      );
    });
  });

  group('PasswordViewModel', () {
    group('copyWith', () {
      group(
        'should return a new instance of [PasswordViewModel] with given values',
        () {
          for (final values in [
            [
              const PasswordViewModel(value: ''),
              const PasswordViewModel(value: r'805$M$Zh', showError: true)
            ],
            [
              const PasswordViewModel(value: '9d!r', showError: true),
              const PasswordViewModel(value: '9bf*')
            ],
          ]) {
            test(values.toString(), () {
              final original = values[0];
              final copy = values[1];

              final result = original.copyWith(
                value: copy.value,
                showError: copy.showError,
              );

              expect(result, copy);
            });
          }
        },
      );
    });
  });
}
