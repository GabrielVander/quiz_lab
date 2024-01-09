import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/common/ui/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/ui/design_system/button/link.dart';
import 'package:quiz_lab/core/ui/design_system/button/primary.dart';
import 'package:quiz_lab/core/ui/design_system/text_field/core.dart';
import 'package:quiz_lab/core/ui/themes/extensions.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/generated/l10n.dart';

class LoginPage extends HookWidget {
  const LoginPage({
    required LoginCubit loginPageCubit,
    required Widget versionDisplayWidget,
    super.key,
  })  : _cubit = loginPageCubit,
        _versionDisplayWidget = versionDisplayWidget;

  final LoginCubit _cubit;
  final Widget _versionDisplayWidget;

  @override
  Widget build(BuildContext context) {
    useBlocListener<LoginCubit, LoginState>(_cubit, (bloc, current, context) {
      if (current.generalErrorCode != null) {
        showSnackBar(context, SnackBar(content: Text(current.generalErrorCode!)));
      }
    });

    useBlocListener<LoginCubit, LoginState>(
      _cubit,
      (_, value, context) {
        if (value.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).goNamed(Routes.questionsOverview.name);
          });
        }
      },
      listenWhen: (LoginState state) => state.success,
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
                  builder: (BuildContext context) {
                    final LoginState state = useBlocBuilder(_cubit);

                    if (state.loading) {
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
                        _LoginForm(
                          key: const ValueKey<String>('loginForm'),
                          email: state.email,
                          password: state.password,
                          onLogin: _cubit.login,
                          onEmailChange: _cubit.updateEmail,
                          onPasswordChange: _cubit.updatePassword,
                          emailErrorCode: state.emailErrorCode,
                          passwordErrorCode: state.passwordErrorCode,
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
    required this.email,
    required this.emailErrorCode,
    required this.password,
    required this.passwordErrorCode,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onLogin,
    super.key,
  });

  final String email;
  final String? emailErrorCode;
  final String password;
  final String? passwordErrorCode;
  final void Function(String newValue) onEmailChange;
  final void Function(String newValue) onPasswordChange;
  final void Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _EmailInput(
            value: email,
            onChange: onEmailChange,
            error: emailErrorCode,
          ),
          const SizedBox(
            height: 15,
          ),
          _PasswordInput(
            value: password,
            onChange: onPasswordChange,
            onSubmited: (_) => onLogin(),
            error: passwordErrorCode,
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
    required this.value,
    required this.error,
    required this.onChange,
  });

  final String value;
  final String? error;
  final void Function(String newValue) onChange;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return QLTextField.standard(
          key: const ValueKey('emailFormField'),
          onChanged: onChange,
          initialValue: value,
          labelText: S.of(context).emailLabel,
          prefixIcon: const Icon(Icons.email),
          errorMessage: error,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.value,
    required this.error,
    required this.onChange,
    required this.onSubmited,
  });

  final String value;
  final String? error;
  final void Function(String) onChange;
  final void Function(String?)? onSubmited;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return QLTextField.standard(
          key: const ValueKey('passwordFormField'),
          labelText: S.of(context).passwordLabel,
          prefixIcon: const Icon(Icons.lock),
          obscureText: true,
          errorMessage: error,
          onChanged: onChange,
          onFieldSubmitted: onSubmited,
          initialValue: value,
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
