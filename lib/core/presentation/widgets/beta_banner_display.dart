import 'package:flutter/material.dart';
import 'package:super_banners/super_banners.dart';

class BetaBannerDisplay extends StatelessWidget {
  const BetaBannerDisplay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const BetaBanner(),
      ],
    );
  }
}

class BetaBanner extends StatelessWidget {
  const BetaBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const PositionedCornerBanner(
      bannerPosition: CornerBannerPosition.topRight,
      bannerColor: Colors.red,
      child: Text('Beta', style: TextStyle(color: Colors.white)),
    );
  }
}
