import 'package:flutter/material.dart';
import 'package:quiz_lab/core/ui/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({
    required QuizLabLogger logger,
    required RetrieveApplicationVersion retrieveApplicationVersion,
    super.key,
  })  : _logger = logger,
        _retrieveApplicationVersion = retrieveApplicationVersion;

  final QuizLabLogger _logger;
  final RetrieveApplicationVersion _retrieveApplicationVersion;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _retrieveApplicationVersion(),
      builder: (context, snap) {
        final hasData = snap.hasData;

        if (hasData) {
          final result = snap.data!.inspectErr(_logger.error);

          return result.when(
            ok: (version) => Text('v$version'),
            err: (e) => Text(e, style: TextStyle(color: Theme.of(context).themeColors.mainColors.error)),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
