import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/ql_button.dart';
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

class _FormInput extends StatefulWidget {
  const _FormInput({
    required this.label,
    required this.icon,
    required this.onChange,
    required this.value,
    super.key,
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
  State<_FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<_FormInput> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).extension<ThemeColors>()!.mainColors.primary;
    final inactiveColor = Theme.of(context).extension<ThemeColors>()!.backgroundColors.disabled;

    final activeInactiveColor = isEditing ? activeColor : inactiveColor;

    return Focus(
      onFocusChange: (bool gainedFocus) {
        setState(() {
          isEditing = gainedFocus;
        });
      },
      child: TextFormField(
        initialValue: widget.value,
        style: Theme.of(context).textTheme.titleMedium,
        onChanged: widget.onChange,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          errorText: widget.errorMessage,
          prefixIcon: Icon(
            widget.icon,
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
          hintText: widget.label,
          hintStyle: TextStyle(
            color: inactiveColor,
          ),
          labelText: widget.label,
          floatingLabelStyle: TextStyle(
            color: activeInactiveColor,
          ),
        ),
      ),
    );
  }
}
