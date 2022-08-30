import 'package:flutter/material.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(child: Body()),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PageTitle(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Form(),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      'Create Question',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 20;
          case TabletBreakpoint:
            return 22;
          case DesktopBreakpoint:
            return 24;
          default:
            return 22;
        }
      },
    );
  }
}

class Form extends StatelessWidget {
  const Form({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: const [
              Expanded(
                child: ShortDescriptionField(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: const [
              Expanded(
                child: DescriptionField(),
              ),
            ],
          ),
        ),
        const Options(),
      ],
    );
  }
}

class ShortDescriptionField extends StatelessWidget {
  const ShortDescriptionField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Short Description',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      minLines: 3,
      maxLines: 3,
    );
  }
}

class Options extends StatelessWidget {
  const Options({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Subtitle(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            OutlinedButton(onPressed: () {}, child: const Text('Add Option'))
          ],
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      'Options',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 16;
          case TabletBreakpoint:
            return 18;
          case DesktopBreakpoint:
            return 20;
          default:
            return 16;
        }
      },
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Option #',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(value: false, onChanged: (bool? _) {}),
            const Text('Is Correct')
          ],
        )
      ],
    );
  }
}
