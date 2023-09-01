import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    required this.imageAssetName,
    required this.imageHeight,
    required this.message,
    required this.fontSize,
    super.key,
  });

  final String imageAssetName;
  final double imageHeight;
  final String message;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imageAssetName,
          height: imageHeight,
        ),
        const SizedBox(
          height: 25,
        ),
        _Message(
          message: message,
          fontSize: fontSize,
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.fontSize,
  });

  final String message;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
