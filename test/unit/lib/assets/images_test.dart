/// Generated by spider on 2022-07-10 11:45:17.208291
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/assets/images.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.appIconIconOnly).existsSync(), true);
  });
}