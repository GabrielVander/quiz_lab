import 'package:flutter/material.dart';

class SimpleLoading extends StatelessWidget {
  const SimpleLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
