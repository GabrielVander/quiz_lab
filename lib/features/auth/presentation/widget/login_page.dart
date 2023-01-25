import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/ghost_pill_text_button.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/generated/l10n.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: Theme.of(context).textTheme.displayLarge!.fontSize,
                child: const QuizLabIcon(),
              ),
              const Center(
                child: _Title(),
              ),
              const _LoginForm(
                key: ValueKey<String>('loginForm'),
              ),
              const _AlternativeOptions()
            ],
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
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _FormInput(
            key: const ValueKey('emailFormField'),
            label: S.of(context).emailLabel,
            icon: Icons.email,
            onChanged: (newValue) {},
          ),
          const SizedBox(
            height: 15,
          ),
          _FormInput(
            key: const ValueKey('passwordFormField'),
            label: S.of(context).passwordLabel,
            icon: Icons.lock,
            obscureText: true,
            onChanged: (newValue) {},
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            key: const ValueKey('loginButton'),
            onPressed: () {
              GoRouter.of(context).pushReplacementNamed(Routes.home.name);
            },
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

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Divider(),
        GhostPillTextButton(
          key: const ValueKey('enterAnonymouslyButton'),
          onPressed: () {},
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
              onPressed: () {},
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
    required this.onChanged,
    this.obscureText = false,
  });

  final String label;
  final IconData icon;
  final bool obscureText;
  final void Function(String newValue) onChanged;

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
        style: Theme.of(context).textTheme.titleMedium,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
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
