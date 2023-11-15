import 'package:flutter/material.dart';

class ConfigurationsScreen extends StatelessWidget {
  const ConfigurationsScreen({required this.options, this.bottomWidget, super.key});

  final List<ListTile> options;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) => options[i],
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemCount: options.length,
              ),
            ),
            if (bottomWidget == null) Container() else bottomWidget!,
          ],
        ),
      ),
    );
  }
}
