import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/ui/themes/light_theme.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';

class VersionDisplay extends HookWidget {
  const VersionDisplay({
    required VersionDisplayCubit cubit,
    super.key,
  }) : _cubit = cubit;

  final VersionDisplayCubit _cubit;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        unawaited(_cubit.displayApplicationVersion());

        return null;
      },
      [],
    );

    final state = useBlocBuilder(_cubit);

    useBlocListener<VersionDisplayCubit, VersionDisplayState>(
      _cubit,
      (bloc, current, context) {
        if (current.errorCode != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(current.errorCode!, style: TextStyle(color: Theme.of(context).themeColors.mainColors.error)),
            ),
          );
        }
      },
      listenWhen: (current) => current.errorCode != null,
    );

    if (state.isLoading) {
      return const CircularProgressIndicator();
    }

    return Text(state.version);
  }
}
