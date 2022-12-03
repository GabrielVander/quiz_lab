import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/assets/resources.dart';
import 'package:quiz_lab/core/presentation/widgets/image_message.dart';

void main() {
  group('should display correct data', () {
    for (final testCase in [
      const _TestCase(
        imageAssetName: Images.appIconIconOnly,
        imageHeight: 73,
        message: 'redden',
        fontSize: 56,
      ),
      const _TestCase(
        imageAssetName: Images.forklift,
        imageHeight: 82,
        message:
            'Ecce, extum! Germanus heuretes inciviliter quaestios solem est.',
        fontSize: 7,
      )
    ]) {
      testWidgets(testCase.toString(), (widgetTester) async {
        await widgetTester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: ImageMessage(
              imageAssetName: testCase.imageAssetName,
              imageHeight: testCase.imageHeight,
              message: testCase.message,
              fontSize: testCase.fontSize,
            ),
          ),
        );

        expect(find.image(AssetImage(testCase.imageAssetName)), findsOneWidget);
        expect(find.text(testCase.message), findsOneWidget);
      });
    }
  });
}

class _TestCase {
  const _TestCase({
    required this.imageAssetName,
    required this.imageHeight,
    required this.message,
    required this.fontSize,
  });

  final String imageAssetName;
  final double imageHeight;
  final String message;
  final double fontSize;

  @override
  String toString() {
    return '_TestCase{ '
        'imageAssetName: $imageAssetName, '
        'imageHeight: $imageHeight, '
        'message: $message, '
        'fontSize: $fontSize, '
        '}';
  }

  _TestCase copyWith({
    String? imageAssetName,
    double? imageHeight,
    String? message,
    double? fontSize,
  }) {
    return _TestCase(
      imageAssetName: imageAssetName ?? this.imageAssetName,
      imageHeight: imageHeight ?? this.imageHeight,
      message: message ?? this.message,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
