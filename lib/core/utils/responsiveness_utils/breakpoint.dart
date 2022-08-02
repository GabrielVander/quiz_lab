enum BoundType { lowerBound, upperBound }

abstract class Breakpoint {
  Breakpoint({
    required this.value,
    this.boundType = BoundType.lowerBound,
  });

  double value;
  BoundType boundType = BoundType.lowerBound;

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
}

class MobileBreakpoint extends Breakpoint {
  MobileBreakpoint() : super(value: 600, boundType: BoundType.upperBound);
}

class TabletBreakpoint extends Breakpoint {
  TabletBreakpoint() : super(value: 600);
}

class DesktopBreakpoint extends Breakpoint {
  DesktopBreakpoint() : super(value: 992);
}
