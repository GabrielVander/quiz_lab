import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('equality test on classes with no props', () {
    expect(_SomeClass(), _SomeClass());
  });
}

class _SomeClass extends Equatable {
  @override
  List<Object?> get props => [];
}
