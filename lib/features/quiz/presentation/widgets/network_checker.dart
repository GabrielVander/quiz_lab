import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/generated/l10n.dart';

class NetworkChecker extends HookWidget {
  const NetworkChecker({
    super.key,
    required this.cubit,
    required this.child,
  });

  final NetworkCubit cubit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    if (state is NetworkInitial) {
      cubit.update();
    }

    if (state is NetworkChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!state.connected) {
          ScaffoldMessenger.of(context)
              .showMaterialBanner(_buildNoConnectionBanner(context));
        } else {
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        }
      });
    }

    return child;
  }

  MaterialBanner _buildNoConnectionBanner(BuildContext context) {
    return MaterialBanner(
      content: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).noConnection,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(),
      ],
    );
  }
}
