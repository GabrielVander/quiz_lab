import 'package:flutter/material.dart';

enum BoundType { lowerBound, upperBound }

@immutable
abstract class Breakpoint {
  const Breakpoint({
    required this.value,
    this.boundType = BoundType.lowerBound,
  });

  final double value;
  final BoundType boundType;

  bool applies(double measurement) {
    switch (boundType) {
      case BoundType.upperBound:
        {
          return measurement <= value;
        }
      case BoundType.lowerBound:
        {
          return measurement >= value;
        }
    }
  }

//<editor-fold desc="Data Methods">

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Breakpoint &&
          runtimeType == other.runtimeType &&
          boundType == other.boundType);

  @override
  int get hashCode => boundType.hashCode;

  @override
  String toString() {
    return 'Breakpoint{ boundType: $boundType,}';
  }

//</editor-fold>
}

@immutable
class UnknownBreakpoint implements Breakpoint {
  @override
  final BoundType boundType = BoundType.lowerBound;

  @override
  final double value = 0;

  @override
  bool applies(double measurement) {
    return false;
  }
}

@immutable
class MobileBreakpoint extends Breakpoint {
  const MobileBreakpoint() : super(value: 600, boundType: BoundType.upperBound);
}

@immutable
class TabletBreakpoint extends Breakpoint {
  const TabletBreakpoint() : super(value: 600);
}

@immutable
class DesktopBreakpoint extends Breakpoint {
  const DesktopBreakpoint() : super(value: 992);
}
