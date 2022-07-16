import 'package:flutter/material.dart';
import 'package:quiz_lab/core/assets/images.dart';
import 'package:sizer/sizer.dart';

class QuizLabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizLabAppBar({
    super.key,
    required this.height,
    required this.padding,
  });

  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: const [
              Expanded(
                child: LeadingIcon(
                  key: ValueKey('appBarIcon'),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Add
                Text(
                  'Quiz Lab',
                  key: const ValueKey('appBarTitle'),
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
          ),
          const SettingsAction(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}

class LeadingIcon extends StatelessWidget {
  const LeadingIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.appIconIconOnly,
      fit: BoxFit.scaleDown,
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('appBarSettingsButton'),
      onPressed: () => {},
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}
