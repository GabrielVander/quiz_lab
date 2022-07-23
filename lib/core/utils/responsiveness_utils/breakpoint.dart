enum BoundType { lowerBound, upperBound }

abstract class Breakpoint {
  Breakpoint({
    required this.value,
    this.boundType = BoundType.lowerBound,
  });

  double value;
  BoundType boundType = BoundType.upperBound;

  bool applies(double measurement) {
    switch (boundType) {
      case BoundType.upperBound:
        {
          return measurement >= value;
        }
      case BoundType.lowerBound:
        {
          return measurement <= value;
        }
    }
  }
}

class MobileBreakpoint extends Breakpoint {
  MobileBreakpoint() : super(value: 600, boundType: BoundType.lowerBound);
}
