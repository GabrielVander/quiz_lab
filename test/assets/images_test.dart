import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/assets/images.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.appIconIconOnly).existsSync(), true);
    expect(File(Images.forklift).existsSync(), true);
  });
}
