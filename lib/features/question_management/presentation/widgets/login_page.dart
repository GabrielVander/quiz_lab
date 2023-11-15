import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/common/ui/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/ui/design_system/button/link.dart';
import 'package:quiz_lab/core/ui/design_system/button/primary.dart';
import 'package:quiz_lab/core/ui/design_system/text_field/core.dart';
import 'package:quiz_lab/core/ui/themes/extensions.dart';
import 'package:quiz_lab/core/ui/themes/light_theme.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/generated/l10n.dart';

class LoginPage extends HookWidget {
  const LoginPage({
    required LoginPageCubit loginPageCubit,
    required Widget versionDisplayWidget,
    super.key,
  })  : _cubit = loginPageCubit,
        _versionDisplayWidget = versionDisplayWidget;

  final LoginPageCubit _cubit;
  final Widget _versionDisplayWidget;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        _cubit.hydrate();

        return null;
      },
      [],
    );

    useBlocListener<LoginPageCubit, LoginPageState>(
      _cubit,
      (_, value, context) {
        final snackBar = switch (value) {
          LoginPageNotYetImplemented() => SnackBar(
              content: Text(
                S.of(context).notYetImplemented,
              ),
            ),
          LoginPageError() => SnackBar(
              backgroundColor: Theme.of(context).themeColors.mainColors.error,
              content: Text(
                S.of(context).genericErrorMessage,
              ),
            ),
          LoginPageUnableToLogin() => SnackBar(
              backgroundColor: Theme.of(context).themeColors.mainColors.error,
              content: Text(
                S.of(context).unableToLogin,
              ),
            ),
          _ => SnackBar(
              content: Text(
                S.of(context).genericErrorMessage,
              ),
            ),
        };

        showSnackBar(context, snackBar);
      },
      listenWhen: (state) =>
          state is LoginPageNotYetImplemented || state is LoginPageError || state is LoginPageUnableToLogin,
    );

    useBlocListener<LoginPageCubit, LoginPageState>(
      _cubit,
      (_, value, context) {
        switch (value) {
          case LoginPagePushRouteReplacing():
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(context).goNamed(value.route.name);
            });
          default:
            break;
        }
      },
      listenWhen: (state) => state is LoginPagePushRouteReplacing,
    );

    return SafeArea(
      child: Scaffold(
        body: BetaBannerDisplay(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final separator = SizedBox(height: constraints.maxHeight * 0.1);

                return HookBuilder(
                  builder: (context) {
                    final loadingState = useBlocBuilder(_cubit);

                    if (loadingState is LoginPageLoading || loadingState is LoginPageInitial) {
                      return const _Loading();
                    }

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
                        HookBuilder(
                          builder: (context) {
                            final state = useBlocBuilder(
                              _cubit,
                              buildWhen: (current) => current is LoginPageViewModelUpdated,
                            );

                            if (state is LoginPageViewModelUpdated) {
                              return _LoginForm(
                                key: const ValueKey<String>('loginForm'),
                                emailViewModel: state.viewModel.email,
                                passwordViewModel: state.viewModel.password,
                                onLogin: _cubit.login,
                                onEmailChange: _cubit.updateEmail,
                                onPasswordChange: _cubit.updatePassword,
                              );
                            }

                            return Container();
                          },
                        ),
                        separator,
                        _AlternativeOptions(
                          onEnterAnonymously: _cubit.enterAnonymously,
                          onSignUp: _cubit.signUp,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(child: _versionDisplayWidget),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, SnackBar snackBar) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
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
            onSubmited: (_) => onLogin(),
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
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.viewModel,
    required this.onChange,
    required this.onSubmited,
  });

  final PasswordViewModel viewModel;
  final void Function(String) onChange;
  final void Function(String?)? onSubmited;

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
          labelText: S.of(context).passwordLabel,
          prefixIcon: const Icon(Icons.lock),
          obscureText: true,
          errorMessage: errorMessage,
          onChanged: onChange,
          onFieldSubmitted: onSubmited,
          initialValue: viewModel.value,
          textInputAction: TextInputAction.done,
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
        QLLinkButton.text(
          key: const ValueKey('enterAnonymouslyButton'),
          onPressed: onEnterAnonymously,
          text: S.of(context).enterAnonymouslyButtonLabel,
        ),
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
            ),
          ],
        ),
      ],
    );
  }
}
