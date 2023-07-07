import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/link.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/primary.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/text_field/core.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/generated/l10n.dart';

class LoginPage extends HookWidget {
  const LoginPage({
    required LoginPageCubit loginPageCubit,
    super.key,
  }) : _cubit = loginPageCubit;

  final LoginPageCubit _cubit;

  @override
  Widget build(BuildContext context) {
    useBlocListener(
      _cubit,
      (bloc, current, context) {
        if (current is LoginPageDisplayNotYetImplementedMessage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).notYetImplemented),
              ),
            );
          });
        }
      },
      listenWhen: (current) => current is LoginPageDisplayNotYetImplementedMessage,
    );

    useBlocListener(
      _cubit,
      (bloc, current, context) {
        if (current is LoginPageDisplayErrorMessage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(S.of(context).genericErrorMessage),
              ),
            );
          });
        }
      },
      listenWhen: (current) => current is LoginPageDisplayErrorMessage,
    );

    useBlocListener(
      _cubit,
      (bloc, current, context) {
        if (current is LoginPagePushRouteReplacing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).goNamed(current.route.name);
          });
        }
      },
      listenWhen: (current) => current is LoginPagePushRouteReplacing,
    );

    final state = useBlocBuilder(
      _cubit,
      buildWhen: (current) => [
        LoginPageInitial,
        LoginPageLoading,
        LoginPageViewModelUpdated,
      ].contains(current.runtimeType),
    );

    return SafeArea(
      child: Scaffold(
        body: BetaBannerDisplay(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: HookBuilder(
              builder: (context) {
                if (state is LoginPageInitial) {
                  _cubit.hydrate();
                }

                if (state is LoginPageInitial || state is LoginPageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LoginPageViewModelUpdated) {
                  return LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final separator = SizedBox(
                        height: constraints.maxHeight * 0.1,
                      );

                      return ListView(
                        children: [
                          SizedBox(
                            height: Theme.of(context).textTheme.displayLarge!.fontSize,
                            child: const QuizLabIcon(),
                          ),
                          separator,
                          const Center(
                            child: _Title(),
                          ),
                          separator,
                          _LoginForm(
                            key: const ValueKey<String>('loginForm'),
                            emailViewModel: state.viewModel.email,
                            passwordViewModel: state.viewModel.password,
                            onLogin: _cubit.onLogin,
                            onEmailChange: _cubit.onEmailChange,
                            onPasswordChange: _cubit.onPasswordChange,
                          ),
                          separator,
                          _AlternativeOptions(
                            onEnterAnonymously: _cubit.onEnterAnonymously,
                            onSignUp: _cubit.onSignUp,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Text(
                              key: const ValueKey('applicationVersion'),
                              state.viewModel.applicationVersion,
                            ),
                          )
                        ],
                      );
                    },
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      S.of(context).loginPageDisplayTitle,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).extension<ThemeColors>()!.textColors.primary,
          ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailViewModel,
    required this.passwordViewModel,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onLogin,
    super.key,
  });

  final EmailViewModel emailViewModel;
  final PasswordViewModel passwordViewModel;
  final void Function(String newValue) onEmailChange;
  final void Function(String newValue) onPasswordChange;
  final void Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _EmailInput(
            viewModel: emailViewModel,
            onChange: onEmailChange,
          ),
          const SizedBox(
            height: 15,
          ),
          _PasswordInput(
            viewModel: passwordViewModel,
            onChange: onPasswordChange,
          ),
          const SizedBox(
            height: 15,
          ),
          QLPrimaryButton.text(
            key: const ValueKey('loginButton'),
            text: S.of(context).logInButtonLabel,
            onPressed: onLogin,
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    required this.viewModel,
    required this.onChange,
  });

  final EmailViewModel viewModel;
  final void Function(String newValue) onChange;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        String? errorMessage;

        if (viewModel.isEmpty && viewModel.showError) {
          errorMessage = S.of(context).mustBeSetMessage;
        }

        return QLTextField.standard(
          key: const ValueKey('emailFormField'),
          onChanged: onChange,
          initialValue: viewModel.value,
          labelText: S.of(context).emailLabel,
          prefixIcon: const Icon(Icons.email),
          errorMessage: errorMessage,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.viewModel,
    required this.onChange,
  });

  final PasswordViewModel viewModel;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        String? errorMessage;

        if (viewModel.isEmpty && viewModel.showError) {
          errorMessage = S.of(context).mustBeSetMessage;
        }

        return QLTextField.standard(
          key: const ValueKey('passwordFormField'),
          placeholderText: S.of(context).passwordLabel,
          prefixIcon: const Icon(Icons.lock),
          obscureText: true,
          errorMessage: errorMessage,
          onChanged: onChange,
          initialValue: viewModel.value,
        );
      },
    );
  }
}

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions({
    required this.onEnterAnonymously,
    required this.onSignUp,
  });

  final void Function() onEnterAnonymously;
  final void Function() onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GhostPillTextButton(
        //   key: const ValueKey('enterAnonymouslyButton'),
        //   onPressed: onEnterAnonymously,
        //   child: Text(S.of(context).enterAnonymouslyButtonLabel),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).dontHaveAnAccountPhrase,
            ),
            QLLinkButton.text(
              key: const ValueKey('signUpButton'),
              onPressed: onSignUp,
              text: S.of(context).loginPageSignUpButtonLabel,
            )
          ],
        ),
      ],
    );
  }
}
