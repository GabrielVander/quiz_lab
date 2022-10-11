import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/assets/resources.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/fork_lift_message.dart';

void main() {
  group('should display correct data', () {
    for (final message in ['message']) {
      testWidgets(message, (widgetTester) async {
        await widgetTester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ForkLiftMessage(
                message: message,
              ),
            ),
          ),
        );

        expect(find.image(const AssetImage(Images.forklift)), findsOneWidget);
        expect(find.text(message), findsOneWidget);
      });
    }
  });
}
