import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/ghost_pill_text_button.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/generated/l10n.dart';

class LoginPage extends HookWidget {
  const LoginPage({
    super.key,
    required LoginPageCubit loginPageCubit,
  }) : _cubit = loginPageCubit;

  final LoginPageCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(_cubit);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Builder(
            builder: (context) {
              if (state is LoginPageInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoginPagePushRouteReplacing) {
                GoRouter.of(context).pushReplacementNamed(state.route.name);
              }

              if (state is LoginPageViewModelUpdated) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: constraints.maxHeight * 0.1,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return [
                          SizedBox(
                            height: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .fontSize,
                            child: const QuizLabIcon(),
                          ),
                          const Center(
                            child: _Title(),
                          ),
                          _LoginForm(
                            key: const ValueKey<String>('loginForm'),
                            emailViewModel: state.viewModel.email,
                            passwordViewModel: state.viewModel.password,
                            onLogin: _cubit.onLogin,
                            onEmailChange: _cubit.onEmailChange,
                            onPasswordChange: _cubit.onPasswordChange,
                          ),
                          _AlternativeOptions(
                            onEnterAnonymously: _cubit.onEnterAnonymously,
                            onSignUp: _cubit.onSignUp,
                          )
                        ][index];
                      },
                    );
                  },
                );
              }

              return Container();
            },
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
            color:
                Theme.of(context).extension<ThemeColors>()!.textColors.primary,
          ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.emailViewModel,
    required this.passwordViewModel,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onLogin,
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
          ElevatedButton(
            key: const ValueKey('loginButton'),
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            child: Text(S.of(context).logInButtonLabel),
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

        return _FormInput(
          key: const ValueKey('emailFormField'),
          label: S.of(context).emailLabel,
          icon: Icons.email,
          errorMessage: errorMessage,
          onChange: onChange,
          value: viewModel.value,
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

        return _FormInput(
          key: const ValueKey('passwordFormField'),
          label: S.of(context).passwordLabel,
          icon: Icons.lock,
          obscureText: true,
          errorMessage: errorMessage,
          onChange: onChange,
          value: viewModel.value,
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
        const Divider(),
        GhostPillTextButton(
          key: const ValueKey('enterAnonymouslyButton'),
          onPressed: onEnterAnonymously,
          child: Text(S.of(context).enterAnonymouslyButtonLabel),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).dontHaveAnAccountPhrase,
            ),
            TextButton(
              key: const ValueKey('signUpButton'),
              onPressed: onSignUp,
              child: Text(S.of(context).loginPageSignUpButtonLabel),
            )
          ],
        ),
      ],
    );
  }
}

class _FormInput extends HookWidget {
  const _FormInput({
    super.key,
    required this.label,
    required this.icon,
    required this.onChange,
    required this.value,
    this.errorMessage,
    this.obscureText = false,
  });

  final String label;
  final IconData icon;
  final bool obscureText;
  final String value;
  final String? errorMessage;
  final void Function(String newValue) onChange;

  @override
  Widget build(BuildContext context) {
    final isEditing = useState(false);
    final activeColor =
        Theme.of(context).extension<ThemeColors>()!.mainColors.primary;
    final inactiveColor =
        Theme.of(context).extension<ThemeColors>()!.backgroundColors.disabled;

    final activeInactiveColor = isEditing.value ? activeColor : inactiveColor;

    return Focus(
      onFocusChange: (bool gainedFocus) {
        isEditing.value = gainedFocus;
      },
      child: TextFormField(
        initialValue: value,
        style: Theme.of(context).textTheme.titleMedium,
        onChanged: onChange,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errorMessage,
          prefixIcon: Icon(
            icon,
            color: activeInactiveColor,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: activeColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: activeInactiveColor.withOpacity(0.075),
          hintText: label,
          hintStyle: TextStyle(
            color: inactiveColor,
          ),
          labelText: label,
          floatingLabelStyle: TextStyle(
            color: activeInactiveColor,
          ),
        ),
      ),
    );
  }
}
