import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/ghost_pill_text_button.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/core/utils/routes.dart';

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
              Center(
                child: Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context)
                            .extension<ThemeColors>()!
                            .textColors
                            .primary,
                      ),
                ),
              ),
              Form(
                key: const ValueKey<String>('loginForm'),
                child: Column(
                  children: [
                    _FormInput(
                      key: const ValueKey('emailFormField'),
                      label: 'Email',
                      icon: Icons.email,
                      onChanged: (newValue) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _FormInput(
                      key: const ValueKey('passwordFormField'),
                      label: 'Password',
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
                        GoRouter.of(context)
                            .pushReplacementNamed(Routes.home.name);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: const Text('Log in'),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Divider(),
                  GhostPillTextButton(
                    key: const ValueKey('enterAnonymouslyButton'),
                    onPressed: () {},
                    child: const Text('Enter anonymously'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                      ),
                      TextButton(
                        key: const ValueKey('signUpButton'),
                        onPressed: () {},
                        child: const Text('Sign Up'),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
